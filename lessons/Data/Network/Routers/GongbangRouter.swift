//
//  GongbangRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 공방 관련 API Router
enum GongbangRouter {
    /// 공방 목록 조회
    case getList(GongbangListQuery)

    /// 공방 상세 조회
    case getDetail(gongbangId: String)

    /// NEW 공방 조회
    case getNewList(GongbangListQuery)

    /// 공방 검색
    case search(GongbangSearchQuery)

    /// 북마크 토글
    case toggleBookmark(gongbangId: String, BookmarkToggleDTO)

    /// 내 북마크 목록
    case getMyBookmarks(GongbangListQuery)
}

// MARK: - Router

extension GongbangRouter: Router {

    var path: String {
        switch self {
        case .getList:
            return "/v1/activities"
        case .getDetail(let gongbangId):
            return "/v1/activities/\(gongbangId)"
        case .getNewList:
            return "/v1/activities/new"
        case .search:
            return "/v1/activities/search"
        case .toggleBookmark(let gongbangId, _):
            return "/v1/activities/\(gongbangId)/keep"
        case .getMyBookmarks:
            return "/v1/activities/keeps/me"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getList, .getDetail, .getNewList, .search, .getMyBookmarks:
            return .get
        case .toggleBookmark:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getList(let query):
            return query.toDictionary()

        case .getDetail:
            return nil

        case .getNewList(let query):
            return query.toDictionary()

        case .search(let query):
            return query.toDictionary()

        case .toggleBookmark(_, let request):
            return request.toDictionary()

        case .getMyBookmarks(let query):
            return query.toDictionary()
        }
    }
}

// MARK: - Request Models

/// 공방 목록 조회 쿼리
struct GongbangListQuery: Encodable {
    let country: String?
    let category: String?
    let limit: Int?
    let next: String?

    init(region: String? = nil, category: String? = nil, limit: Int? = nil, cursor: String? = nil) {
        self.country = region
        self.category = category
        self.limit = limit
        self.next = cursor
    }

    // nil 값은 제외하고 인코딩
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try country.map { try container.encode($0, forKey: .country) }
        try category.map { try container.encode($0, forKey: .category) }
        try limit.map { try container.encode($0, forKey: .limit) }
        try next.map { try container.encode($0, forKey: .next) }
    }

    private enum CodingKeys: String, CodingKey {
        case country, category, limit, next
    }
}

/// 공방 검색 쿼리
struct GongbangSearchQuery: Encodable {
    let title: String

    init(keyword: String) {
        self.title = keyword
    }
}
