//
//  ImagePickerManager.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

/// 미디어 타입
enum MediaType {
    case image
    case video
    case imageAndVideo
}

/// 선택된 미디어 결과
enum MediaResult {
    case image(UIImage)
    case video(URL)
}

/// 이미지/동영상 선택 관리자 (PHPickerViewController 래퍼)
final class ImagePickerManager: NSObject {

    // MARK: - Properties
    private let imageSubject = PublishSubject<UIImage>()
    private let mediaSubject = PublishSubject<MediaResult>()
    private weak var presentingViewController: UIViewController?

    // MARK: - Public Methods

    /// 이미지 선택 (기존 메서드 - 하위 호환성 유지)
    /// - Parameter viewController: 현재 ViewController
    /// - Returns: 선택된 이미지 Observable
    func pickImage(from viewController: UIViewController) -> Observable<UIImage> {
        self.presentingViewController = viewController

        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 선택
        configuration.selectionLimit = 1 // 1개만 선택

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true)

        return imageSubject.asObservable()
    }

    /// 미디어 선택 (이미지 또는 동영상)
    /// - Parameters:
    ///   - viewController: 현재 ViewController
    ///   - mediaType: 선택 가능한 미디어 타입
    ///   - selectionLimit: 선택 가능한 개수 (기본값: 1)
    /// - Returns: 선택된 미디어 Observable
    func pickMedia(
        from viewController: UIViewController,
        mediaType: MediaType = .imageAndVideo,
        selectionLimit: Int = 1
    ) -> Observable<MediaResult> {
        self.presentingViewController = viewController

        var configuration = PHPickerConfiguration()

        // 미디어 타입 설정
        switch mediaType {
        case .image:
            configuration.filter = .images
        case .video:
            configuration.filter = .videos
        case .imageAndVideo:
            configuration.filter = .any(of: [.images, .videos])
        }

        configuration.selectionLimit = selectionLimit
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true)

        return mediaSubject.asObservable()
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ImagePickerManager: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }
        let itemProvider = result.itemProvider

        // 이미지 처리
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let error = error {
                        Log.error("이미지 로드 실패: \(error.localizedDescription)")
                        return
                    }

                    guard let image = image as? UIImage else { return }

                    // 기존 imageSubject (하위 호환성)
                    self?.imageSubject.onNext(image)

                    // 새로운 mediaSubject
                    self?.mediaSubject.onNext(.image(image))
                }
            }
            return
        }

        // 동영상 처리
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
                DispatchQueue.main.async {
                    if let error = error {
                        Log.error("동영상 로드 실패: \(error.localizedDescription)")
                        return
                    }

                    guard let url = url else {
                        Log.error("동영상 URL이 nil입니다")
                        return
                    }

                    // 임시 디렉토리에 복사 (원본 파일은 삭제됨)
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let fileName = "\(UUID().uuidString).mov"
                    let localURL = tempDirectory.appendingPathComponent(fileName)

                    do {
                        // 기존 파일이 있으면 삭제
                        if FileManager.default.fileExists(atPath: localURL.path) {
                            try FileManager.default.removeItem(at: localURL)
                        }

                        try FileManager.default.copyItem(at: url, to: localURL)
                        self?.mediaSubject.onNext(.video(localURL))

                        Log.info("동영상 로드 성공: \(localURL.path)")
                    } catch {
                        Log.error("동영상 복사 실패: \(error.localizedDescription)")
                    }
                }
            }
            return
        }
    }
}
