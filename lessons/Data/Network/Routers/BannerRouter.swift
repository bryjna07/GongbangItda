//
//  BannerRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 배너 관련 API Router
enum BannerRouter {
    /// 메인 배너 조회
    case fetchMainBanners
}

// MARK: - Router

extension BannerRouter: Router {

    var path: String {
        switch self {
        case .fetchMainBanners:
            return "/v1/banners/main"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMainBanners:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchMainBanners:
            return nil
        }
    }
}
