//
//  MainTabBarController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import UIKit
import SnapKit
import Then

/// 메인 탭바 컨트롤러
final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    private let homeNavigationController = UINavigationController()
    private let searchNavigationController = UINavigationController()
    private let bookmarkNavigationController = UINavigationController()
    private let profileNavigationController = UINavigationController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
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
    
    private func setupViewControllers() {
        // 홈 탭
        let homeVC = PlaceholderViewController(
            title: TabItem.home.title,
            message: TabItem.home.message
        )
        homeNavigationController.viewControllers = [homeVC]
        homeNavigationController.tabBarItem = TabItem.home.tabBarItem
        
        // 카테고리 탭
        let categoryVC = PlaceholderViewController(
            title: TabItem.search.title,
            message: TabItem.search.message
        )
        searchNavigationController.viewControllers = [categoryVC]
        searchNavigationController.tabBarItem = TabItem.search.tabBarItem
        
        // 북마크 탭
        let bookmarkVC = PlaceholderViewController(
            title: TabItem.bookmark.title,
            message: TabItem.bookmark.message
        )
        bookmarkNavigationController.viewControllers = [bookmarkVC]
        bookmarkNavigationController.tabBarItem = TabItem.bookmark.tabBarItem
        
        // 설정 탭
        let profileVC = PlaceholderViewController(
            title: TabItem.profile.title,
            message: TabItem.profile.message
        )
        profileNavigationController.viewControllers = [profileVC]
        profileNavigationController.tabBarItem = TabItem.profile.tabBarItem
        
        viewControllers = [
            homeNavigationController,
            searchNavigationController,
            bookmarkNavigationController,
            profileNavigationController
        ]
    }
    
    // MARK: - Public Methods
    func getNavigationController(for index: Int) -> UINavigationController? {
        guard index < viewControllers?.count ?? 0 else { return nil }
        return viewControllers?[index] as? UINavigationController
    }
}


// MARK: - Tab Item Configuration

private enum TabItem {
    case home
    case search
    case bookmark
    case profile
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .search: return "검색"
        case .bookmark: return "북마크"
        case .profile: return "프로필"
        }
    }
    
    var message: String {
        switch self {
        case .home: return "홈 화면\n(작업 예정)"
        case .search: return "검색 화면\n(작업 예정)"
        case .bookmark: return "북마크 화면\n(작업 예정)"
        case .profile: return "프로필 화면\n(작업 예정)"
        }
    }
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(
                title: title,
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        case .search:
            return UITabBarItem(
                title: title,
                image: UIImage(systemName: "square.grid.2x2"),
                selectedImage: UIImage(systemName: "square.grid.2x2.fill")
            )
        case .bookmark:
            return UITabBarItem(
                title: title,
                image: UIImage(systemName: "bookmark"),
                selectedImage: UIImage(systemName: "bookmark.fill")
            )
        case .profile:
            return UITabBarItem(
                title: title,
                image: UIImage(systemName: "gearshape"),
                selectedImage: UIImage(systemName: "gearshape.fill")
            )
        }
    }
}


// MARK: - Placeholder ViewController

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
