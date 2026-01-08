//
//  ProfileCoordinator.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit

/// 프로필 화면 전환 관리
final class ProfileCoordinator: Coordinator {

    // MARK: - Properties
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        Log.debug("[ProfileCoordinator] deinit - 메모리 해제됨")
    }

    // MARK: - Coordinator

    func start() {
        let profileDIContainer = AppDIContainer.shared.makeProfileDIContainer()
        let profileVC = profileDIContainer.makeProfileViewController()
        profileVC.coordinator = self

        navigationController.setViewControllers([profileVC], animated: false)
    }

    func finish() {
        childCoordinators.removeAll()
    }

    // MARK: - Navigation Methods

    /// 설정 화면으로 이동
    func showSettings() {
        // TODO: 설정 화면 구현 시 추가
        // let settingsVC = SettingsViewController()
        // navigationController.pushViewController(settingsVC, animated: true)
    }
}
