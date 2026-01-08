//
//  MainTabCoordinator.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import UIKit

/// 메인 탭바 화면 전환 관리
/// - Note: TabBar 기반이므로 Coordinator 프로토콜을 사용하지 않음
final class MainTabCoordinator {

    // MARK: - Properties
    let tabBarController: MainTabBarController
    private var childCoordinators: [Coordinator] = []

    // MARK: - Tab NavigationControllers
    private let homeNavigationController = UINavigationController()
    private let searchNavigationController = UINavigationController()
    private let bookmarkNavigationController = UINavigationController()
    private let profileNavigationController = UINavigationController()

    // MARK: - Initialization
    init() {
        self.tabBarController = MainTabBarController()
    }

    deinit {
        Log.debug("[MainTabCoordinator] deinit - 메모리 해제됨")
    }

    // MARK: - Lifecycle
    func start() {
        // 각 탭의 Coordinator 설정
        setupChildCoordinators()

        // TabBarController에 NavigationController들 설정
        tabBarController.setTabViewControllers([
            homeNavigationController,
            searchNavigationController,
            bookmarkNavigationController,
            profileNavigationController
        ])
    }

    func finish() {
        childCoordinators.forEach { $0.finish() }
        childCoordinators.removeAll()
    }

    // MARK: - Private Methods
    private func setupChildCoordinators() {
        // 홈 탭 (Placeholder)
        let homeVC = PlaceholderViewController(title: GIStrings.TabBar.home, message: "홈 화면\n(작업 예정)")
        homeNavigationController.setViewControllers([homeVC], animated: false)

        // 검색 탭 (Placeholder)
        let searchVC = PlaceholderViewController(title: GIStrings.TabBar.search, message: "검색 화면\n(작업 예정)")
        searchNavigationController.setViewControllers([searchVC], animated: false)

        // 북마크 탭 (Placeholder)
        let bookmarkVC = PlaceholderViewController(title: GIStrings.TabBar.bookmark, message: "북마크 화면\n(작업 예정)")
        bookmarkNavigationController.setViewControllers([bookmarkVC], animated: false)

        // 프로필 탭 (ProfileCoordinator)
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
}

// MARK: - Placeholder ViewController

import SnapKit
import Then

private final class PlaceholderViewController: BaseViewController {

    private let displayTitle: String
    private let displayMessage: String

    private lazy var messageLabel = UILabel()

    // MARK: - Initialization
    init(title: String, message: String) {
        self.displayTitle = title
        self.displayMessage = message
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        title = displayTitle
        view.backgroundColor = .gray0

        view.addSubview(messageLabel)

        messageLabel.do {
            $0.text = displayMessage
            $0.font = GIFonts.body1
            $0.textColor = .gray75
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }
    }
}
