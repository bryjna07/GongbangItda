//
//  AuthCoordinator.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit

/// 인증 플로우 화면 전환 관리
final class AuthCoordinator: Coordinator {

    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    private let authUseCase: AuthUseCaseProtocol
    private let onAuthComplete: () -> Void

    // MARK: - Initialization
    init(
        navigationController: UINavigationController,
        authUseCase: AuthUseCaseProtocol,
        onAuthComplete: @escaping () -> Void
    ) {
        self.navigationController = navigationController
        self.authUseCase = authUseCase
        self.onAuthComplete = onAuthComplete
    }

    // MARK: - Lifecycle
    deinit {
        Log.debug("[AuthCoordinator] deinit - 메모리 해제됨")
    }

    // MARK: - Coordinator
    func start() {
        showLogin()
    }

    func finish() {
        childCoordinators.removeAll()
    }

    // MARK: - Navigation Methods

    /// 로그인 화면 표시
    func showLogin() {
        let reactor = LoginReactor(useCase: authUseCase)
        let viewController = LoginViewController(reactor: reactor)
        viewController.coordinator = self

        navigationController.setViewControllers([viewController], animated: false)
    }

    /// 이메일 로그인 화면으로 이동
    func showEmailLogin() {
        let reactor = EmailLoginReactor(useCase: authUseCase)
        let viewController = EmailLoginViewController(reactor: reactor)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    /// 회원가입 화면으로 이동
    func showSignUp() {
        let reactor = SignUpReactor(useCase: authUseCase)
        let viewController = SignUpViewController(reactor: reactor)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    /// 회원가입 완료 처리
    func signUpDidComplete() {
        // 회원가입 성공 시 바로 홈으로 이동 (자동 로그인됨)
        onAuthComplete()
    }

    /// 로그인 완료 처리
    func loginDidComplete() {
        // 로그인 성공 시 바로 홈으로 이동 (카카오, 애플 로그인 시 닉네임 랜덤 배정됨)
        onAuthComplete()
    }
}