//
//  SceneDelegate.swift
//  lessons
//
//  Created by Watson22_YJ on 12/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /// 현재 활성화된 Coordinator (Auth 또는 MainTab)
    private var currentCoordinator: Any?

    deinit {
        NotificationCenter.default.removeObserver(self)
        Log.debug("[SceneDelegate] deinit - 메모리 해제됨")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        guard let window = window else { return }

        // 세션 만료 알림 구독
        setupSessionExpirationObserver()

        // Splash 화면에서 토큰 검증 후 분기 처리
        showSplash(window: window)
    }

    // MARK: - Flow Switching

    /// 인증 플로우로 전환
    func switchToAuthFlow() {
        guard let window = window else { return }

        // 기존 Coordinator 정리
        cleanupCurrentCoordinator()

        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)

        let authUseCase = AppDIContainer.shared.resolveAuthUseCase()
        let authCoordinator = AuthCoordinator(
            navigationController: navController,
            authUseCase: authUseCase,
            onAuthComplete: { [weak self] in
                self?.switchToMainFlow()
            }
        )
        currentCoordinator = authCoordinator
        authCoordinator.start()

        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

    /// 메인 탭바 플로우로 전환
    func switchToMainFlow() {
        guard let window = window else { return }

        // 기존 Coordinator 정리
        cleanupCurrentCoordinator()

        let mainTabCoordinator = MainTabCoordinator()
        currentCoordinator = mainTabCoordinator
        mainTabCoordinator.start()

        window.rootViewController = mainTabCoordinator.tabBarController
        window.makeKeyAndVisible()
    }

    // MARK: - Private Methods

    private func showSplash(window: UIWindow) {
        let splashDIContainer = AppDIContainer.shared.makeSplashDIContainer()
        let splashVC = splashDIContainer.makeSplashViewController()

        splashVC.onAuthResult = { [weak self] isAuthenticated in
            if isAuthenticated {
                Log.info("토큰 유효성 검증 성공 - 홈화면으로 이동")
                self?.switchToMainFlow()
            } else {
                Log.info("토큰 유효성 검증 실패 - 로그인 화면으로 이동")
                self?.switchToAuthFlow()
            }
        }

        let navController = UINavigationController(rootViewController: splashVC)
        navController.setNavigationBarHidden(true, animated: false)

        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

    private func setupSessionExpirationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionExpiration),
            name: .sessionExpired,
            object: nil
        )
    }

    @objc private func handleSessionExpiration() {
        Log.info("세션 만료 - 로그인 화면으로 이동")
        DispatchQueue.main.async { [weak self] in
            self?.switchToAuthFlow()
        }
    }

    private func cleanupCurrentCoordinator() {
        if let authCoordinator = currentCoordinator as? AuthCoordinator {
            authCoordinator.finish()
        } else if let mainTabCoordinator = currentCoordinator as? MainTabCoordinator {
            mainTabCoordinator.finish()
        }
        currentCoordinator = nil
    }
}

