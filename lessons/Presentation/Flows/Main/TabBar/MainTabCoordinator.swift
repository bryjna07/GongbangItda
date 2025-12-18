//
//  MainTabCoordinator.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import UIKit

/// 메인 탭바 화면 전환 관리
final class MainTabCoordinator: Coordinator {

    // MARK: - Properties
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let tabBarController: MainTabBarController

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = MainTabBarController()
    }

    // MARK: - Coordinator
    func start() {
        navigationController.setViewControllers([tabBarController], animated: false)
        setupChildCoordinators()
    }

    func finish() {
        childCoordinators.removeAll()
    }

    // MARK: - Private Methods
    private func setupChildCoordinators() {
        // TODO: 각 탭별 Coordinator 생성 및 연결
        // 현재는 빈 화면들로 구성됨
    }
}
