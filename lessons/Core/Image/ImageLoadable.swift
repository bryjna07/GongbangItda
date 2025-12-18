//
//  ImageLoadable.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import UIKit
import Kingfisher

/// 이미지 캐싱 전략 (용도별 TTL 차별화)
enum ImageCacheStrategy {
    /// 썸네일 (리스트용) - 작은 크기, 긴 TTL
    case thumbnail
    /// 상세화면 (큰 이미지) - 큰 크기, 짧은 TTL
    case detail
    /// 배너/이벤트 (자주 변경) - 매우 짧은 TTL
    case banner
    /// 프로필 (거의 불변) - 긴 TTL
    case profile
    /// 커스텀 설정
    case custom(expirationDays: Int)

    /// TTL (일 단위)
    var expirationDays: Int {
        switch self {
        case .thumbnail: return 7      // 자주 보는 썸네일은 길게
        case .detail: return 1         // 가끔 보는 상세는 짧게
        case .banner: return 0         // 배너는 당일만 (자주 변경)
        case .profile: return 30       // 프로필은 길게 (거의 불변)
        case .custom(let days): return days
        }
    }
}

/// 이미지 로딩을 위한 프로토콜
/// - UIImageView extension으로 Kingfisher 기반 이미지 로딩 제공
/// - 다운샘플링을 통한 메모리 최적화
/// - 크기별 캐싱 전략으로 디스크 효율 극대화
/// - prepareForReuse에서 cancelImageLoad() 호출 필수
protocol ImageLoadable: AnyObject {
    /// 이미지 로드 (다운샘플링 + 크기별 캐싱)
    /// - Parameters:
    ///   - urlString: 이미지 URL 문자열
    ///   - placeholder: 로딩 중/실패 시 표시할 이미지
    ///   - downsampleSize: 다운샘플링 크기 (nil이면 ImageView 크기 사용)
    ///   - strategy: 캐싱 전략 (기본값: .thumbnail)
    func setImage(
        with urlString: String?,
        placeholder: UIImage?,
        downsampleSize: CGSize?,
        strategy: ImageCacheStrategy
    )

    /// 진행 중인 이미지 다운로드 취소 (셀 재사용 시 필수)
    func cancelImageLoad()
}

extension UIImageView: ImageLoadable {

    /// Kingfisher 기반 이미지 로딩 (크기별 캐싱)
    ///
    /// **전략**: 원본 캐싱 X, 크기별로 다운샘플링된 이미지만 캐싱
    /// - 썸네일: 40KB, 7일 보관
    /// - 상세화면: 200KB, 1일 보관
    /// - 디스크 효율: 원본(5MB) 대비 60배 이상 절약
    ///
    /// **TODO**: ETag 최적화 (서버 지원 확인 후 추가)
    /// - TTL 만료 시 If-None-Match 헤더 전송
    /// - 304 응답: 0 바이트 다운로드 + 캐시 재사용
    /// - 200 응답: 새 이미지
    func setImage(
        with urlString: String?,
        placeholder: UIImage? = nil,
        downsampleSize: CGSize? = nil,
        strategy: ImageCacheStrategy = .thumbnail
    ) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }

        // 다운샘플링 크기 결정
        let targetSize = downsampleSize ?? bounds.size
        // ImageView의 scale factor (기본값: UIScreen.main.scale)
        // - 일반적으로 UIScreen.main과 동일 (iPhone: 2x/3x 등)
        let scale = UIScreen.main.scale

        // 다운샘플링 프로세서
        let processor = DownsamplingImageProcessor(size: targetSize)

        // 캐싱 전략별 TTL 설정
        let expiration: StorageExpiration = strategy.expirationDays == 0
            ? .seconds(86400)  // 0일 = 24시간
            : .days(strategy.expirationDays)

        // API 헤더 추가 (Key, Authorization)
        let modifier = KingfisherRequestModifier()

        let options: KingfisherOptionsInfo = [
            .processor(processor),              // 다운샘플링 적용
            .scaleFactor(scale),                // Retina 대응
            .diskCacheExpiration(expiration),   // TTL 설정 (전략별)
            .cacheSerializer(FormatIndicatedCacheSerializer.jpeg(compressionQuality: 0.85)), // JPEG 압축 (PNG 대비 70-90% 용량 절감)
            .transition(.fade(0.2)),            // 페이드인 애니메이션
            .backgroundDecode,                  // 백그라운드 디코딩
            .requestModifier(modifier),         // API 헤더
        ]

        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options
        ) { result in
            #if DEBUG
            switch result {
            case .success(let value):
                let cacheType = value.cacheType == .none ? "Network" :
                                value.cacheType == .memory ? "Memory" : "Disk"
                Log.debug("[\(strategy)] 이미지 로드 [\(cacheType)] - \(urlString.suffix(30))")

            case .failure(let error):
                if !error.isTaskCancelled {
                    Log.error("[\(strategy)] 이미지 로드 실패 - \(error.localizedDescription)")
                }
            }
            #endif
        }
    }

    /// 이미지 다운로드 취소
    /// - Note: UICollectionViewCell의 prepareForReuse에서 반드시 호출
    func cancelImageLoad() {
        self.kf.cancelDownloadTask()
    }
}

// MARK: - Convenience Methods

extension UIImageView {

    /// 썸네일 이미지 로드 (리스트용)
    /// - 크기: 100x100 (또는 셀 크기)
    /// - TTL: 7일
    func setThumbnail(with urlString: String?, placeholder: UIImage? = nil) {
        setImage(
            with: urlString,
            placeholder: placeholder,
            downsampleSize: nil,  // bounds.size 사용
            strategy: .thumbnail
        )
    }

    /// 상세 이미지 로드 (상세화면용)
    /// - 크기: 400x300 (또는 ImageView 크기)
    /// - TTL: 1일
    func setDetailImage(with urlString: String?, placeholder: UIImage? = nil) {
        setImage(
            with: urlString,
            placeholder: placeholder,
            downsampleSize: nil,  // bounds.size 사용
            strategy: .detail
        )
    }

    /// 배너 이미지 로드 (자주 변경)
    /// - TTL: 24시간
    func setBannerImage(with urlString: String?, placeholder: UIImage? = nil) {
        setImage(
            with: urlString,
            placeholder: placeholder,
            downsampleSize: nil,
            strategy: .banner
        )
    }

    /// 프로필 이미지 로드 (거의 불변)
    /// - TTL: 30일
    func setProfileImage(with urlString: String?, placeholder: UIImage? = nil) {
        setImage(
            with: urlString,
            placeholder: placeholder,
            downsampleSize: nil,
            strategy: .profile
        )
    }
}

