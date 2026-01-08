//
//  ProfileViewController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

/// 프로필 화면
final class ProfileViewController: BaseViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    weak var coordinator: ProfileCoordinator?

    private lazy var settingButton = UIBarButtonItem(
        image: .icon(GIIcons.settingsFill),
        style: .plain,
        target: nil,
        action: nil
    )

    private let imagePicker = ImagePickerManager()

    // MARK: - UI Components
    private let profileView = ProfileView()

    /// 최초 화면 표시 여부 (프로필 조회 중복 방지)
    private var isFirstAppear = true

    // MARK: - Initialization
    init(reactor: ProfileReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 최초 화면 진입 시에만 프로필 조회
        if isFirstAppear {
            isFirstAppear = false
            reactor?.action.onNext(.viewWillAppear)
        }
    }

    // MARK: - Setup

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = GIStrings.Profile.title
        navigationItem.rightBarButtonItem = settingButton
    }

    // MARK: - Bind
    func bind(reactor: ProfileReactor) {

        // MARK: - Action

        // 설정 버튼 탭
        settingButton.rx.tap
            .map { Reactor.Action.didTapSetting }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 카메라 버튼 탭 → 이미지 선택 → JPEG 압축 후 Action 전달
        // (UIImage 압축은 UIKit 처리이므로 VC에서 수행, 서버 제한 1MB 이하)
        profileView.cameraButton.rx.tap
            .flatMap { [weak self] _ -> Observable<UIImage> in
                guard let self = self else { return .empty() }
                return self.imagePicker.pickImage(from: self)
            }
            .compactMap { [weak self] image -> Data? in
                guard let data = image.compressToJPEG() else {
                    self?.showAlert(title: GIStrings.Common.error, message: GIStrings.Profile.imageCompressionError)
                    return nil
                }
                return data
            }
            .map { Reactor.Action.didSelectImageData($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 수정 버튼 탭
        profileView.editButton.rx.tap
            .map { Reactor.Action.didTapEditButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // MARK: - State

        // 프로필 정보 업데이트
        reactor.state.compactMap { $0.user }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, user in
                owner.profileView.configure(
                    nickname: user.nickname,
                    introduction: user.introduction,
                    profileImageURL: user.profileImageURL,
                    totalAmount: "0원", // TODO: 주문내역 연동
                    totalPoints: "0P",  // TODO: 포인트 연동
                    categories: []      // TODO: 카테고리 연동
                )
            }
            .disposed(by: disposeBag)

        // 에러 메시지
        reactor.state.compactMap { $0.errorMessage }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, message in
                owner.showAlert(title: GIStrings.Common.error, message: message)
            }
            .disposed(by: disposeBag)

        // 로그아웃 알림 표시
        reactor.pulse(\.$showLogoutAlert)
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, _ in
                owner.showLogoutAlert(reactor: reactor)
            }
            .disposed(by: disposeBag)

        // 프로필 수정 모달 표시
        reactor.pulse(\.$showEditModal)
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, _ in
                owner.showEditProfileModal(reactor: reactor)
            }
            .disposed(by: disposeBag)

        // 로그아웃 완료 → 로그인 화면으로 이동
        reactor.pulse(\.$logoutCompleted)
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive { _ in
                NotificationCenter.default.post(name: .sessionExpired, object: nil)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods

    /// 로그아웃 알림 표시
    private func showLogoutAlert(reactor: ProfileReactor) {
        showConfirmAlert(
            title: GIStrings.Profile.logoutConfirmTitle,
            message: GIStrings.Profile.logoutConfirmMessage,
            confirmTitle: GIStrings.Auth.logout,
            confirmStyle: .destructive,
            confirmHandler: {
                // Action을 통해 로그아웃 수행 (단방향 플로우 준수)
                reactor.action.onNext(.didConfirmLogout)
            }
        )
    }

    /// 프로필 수정 모달 표시
    private func showEditProfileModal(reactor: ProfileReactor) {
        guard let user = reactor.currentState.user else { return }

        let editVC = EditProfileViewController(
            nickname: user.nickname,
            phoneNumber: user.phoneNumber,
            introduction: user.introduction
        )

        editVC.onSave = { [weak reactor] nickname, phoneNumber, introduction in
            reactor?.action.onNext(.didConfirmEdit(
                nickname: nickname,
                phoneNumber: phoneNumber,
                introduction: introduction
            ))
        }

        if let sheet = editVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        present(editVC, animated: true)
    }

}
