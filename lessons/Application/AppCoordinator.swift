//
//  AppCoordinator.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import UIKit

/// 앱 전체 화면 전환을 관리하는 최상위 Coordinator
final class AppCoordinator: Coordinator {

    // MARK: - Properties
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let window: UIWindow

    // MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Coordinator
    func start() {
        // TODO: 로그인 상태 확인 후 분기 처리
        // 현재는 바로 MainTab으로 이동
        showMainTab()
    }

    func finish() {
        childCoordinators.removeAll()
    }

    // MARK: - Private Methods
    private func showMainTab() {
        let mainTabCoordinator = MainTabCoordinator(navigationController: navigationController)
        addChild(mainTabCoordinator)
        mainTabCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
