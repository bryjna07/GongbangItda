//
//  MainTabBarController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import UIKit

/// 메인 탭바 컨트롤러
/// - Note: ViewController 생성은 Coordinator에서 담당, TabBar 설정만 수행
final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    // MARK: - Setup

    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .gray0

        appearance.stackedLayoutAppearance.selected.iconColor = .gray90
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.gray90,
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = .gray45
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray45,
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    // MARK: - Public Methods

    /// Coordinator에서 호출하여 탭 설정
    func setTabViewControllers(_ viewControllers: [UINavigationController]) {
        // 탭 아이템 설정
        if viewControllers.count >= 4 {
            viewControllers[0].tabBarItem = TabItem.home.tabBarItem
            viewControllers[1].tabBarItem = TabItem.search.tabBarItem
            viewControllers[2].tabBarItem = TabItem.bookmark.tabBarItem
            viewControllers[3].tabBarItem = TabItem.profile.tabBarItem
        }

        self.viewControllers = viewControllers
    }
}

// MARK: - Tab Item Configuration

private enum TabItem {
    case home
    case search
    case bookmark
    case profile

    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(
                title: GIStrings.TabBar.home,
                image: .icon(GIIcons.home),
                selectedImage: .icon(GIIcons.homeFill)
            )
        case .search:
            return UITabBarItem(
                title: GIStrings.TabBar.search,
                image: .icon(GIIcons.search),
                selectedImage: .icon(GIIcons.searchFill)
            )
        case .bookmark:
            return UITabBarItem(
                title: GIStrings.TabBar.bookmark,
                image: .icon(GIIcons.bookmark),
                selectedImage: .icon(GIIcons.bookmarkFill)
            )
        case .profile:
            return UITabBarItem(
                title: GIStrings.TabBar.profile,
                image: .icon(GIIcons.settings),
                selectedImage: .icon(GIIcons.settingsFill)
            )
        }
    }
}
