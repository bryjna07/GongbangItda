//
//  PostRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 게시글(공방 후기) API Router
enum PostRouter {
    /// 게시글 파일 업로드
    case uploadFiles

    /// 게시글 작성
    case create(CreatePostRequest)

    /// 위치기반 게시글 조회
    case fetchByLocation(PostLocationQuery)

    /// 게시글 검색
    case search(keyword: String)

    /// 게시글 상세 조회
    case fetchDetail(postId: String)

    /// 게시글 수정
    case update(postId: String, UpdatePostRequest)

    /// 게시글 삭제
    case delete(postId: String)

    /// 게시글 좋아요 토글
    case toggleLike(postId: String, LikeToggleDTO)

    /// 유저별 게시글 조회
    case fetchUserPosts(userId: String, PostListQuery)

    /// 내가 좋아요한 게시글 조회
    case fetchMyLikedPosts(PostListQuery)
}

// MARK: - Router

extension PostRouter: Router {

    var path: String {
        switch self {
        case .uploadFiles:
            return "/v1/posts/files"
        case .create:
            return "/v1/posts"
        case .fetchByLocation:
            return "/v1/posts/geolocation"
        case .search:
            return "/v1/posts/search"
        case .fetchDetail(let postId):
            return "/v1/posts/\(postId)"
        case .update(let postId, _):
            return "/v1/posts/\(postId)"
        case .delete(let postId):
            return "/v1/posts/\(postId)"
        case .toggleLike(let postId, _):
            return "/v1/posts/\(postId)/like"
        case .fetchUserPosts(let userId, _):
            return "/v1/posts/users/\(userId)"
        case .fetchMyLikedPosts:
            return "/v1/posts/likes/me"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .uploadFiles, .create, .toggleLike:
            return .post
        case .fetchByLocation, .search, .fetchDetail, .fetchUserPosts, .fetchMyLikedPosts:
            return .get
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    var isMultipartUpload: Bool {
        switch self {
        case .uploadFiles:
            return true
        default:
            return false
        }
    }

    var parameters: Parameters? {
        switch self {
        case .uploadFiles:
            return nil

        case .create(let request):
            return request.toDictionary()

        case .fetchByLocation(let query):
            return query.toDictionary()

        case .search(let keyword):
            return ["title": keyword]

        case .fetchDetail:
            return nil

        case .update(_, let request):
            return request.toDictionary()

        case .delete:
            return nil

        case .toggleLike(_, let request):
            return request.toDictionary()

        case .fetchUserPosts(_, let query):
            return query.toDictionary()

        case .fetchMyLikedPosts(let query):
            return query.toDictionary()
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .fetchByLocation, .search, .fetchUserPosts, .fetchMyLikedPosts:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}

// MARK: - Request Models

/// 게시글 작성 요청
struct CreatePostRequest: Encodable {
    let country: String
    let category: String
    let title: String
    let content: String
    let activityId: String?
    let latitude: Double
    let longitude: Double
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case country, category, title, content
        case activityId = "activity_id"
        case latitude, longitude, files
    }

    init(
        region: String,
        category: String,
        title: String,
        content: String,
        gongbangId: String? = nil,
        latitude: Double,
        longitude: Double,
        files: [String]
    ) {
        self.country = region
        self.category = category
        self.title = title
        self.content = content
        self.activityId = gongbangId
        self.latitude = latitude
        self.longitude = longitude
        self.files = files
    }
}

/// 게시글 수정 요청
struct UpdatePostRequest: Encodable {
    let country: String?
    let category: String?
    let title: String?
    let content: String?
    let activityId: String?
    let latitude: Double?
    let longitude: Double?
    let files: [String]?

    enum CodingKeys: String, CodingKey {
        case country, category, title, content
        case activityId = "activity_id"
        case latitude, longitude, files
    }

    init(
        region: String? = nil,
        category: String? = nil,
        title: String? = nil,
        content: String? = nil,
        gongbangId: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        files: [String]? = nil
    ) {
        self.country = region
        self.category = category
        self.title = title
        self.content = content
        self.activityId = gongbangId
        self.latitude = latitude
        self.longitude = longitude
        self.files = files
    }
}

/// 위치기반 게시글 조회 쿼리
struct PostLocationQuery: Encodable {
    let country: String?
    let category: String?
    let longitude: Double?
    let latitude: Double?
    let maxDistance: Double?
    let orderBy: String?
    let limit: Int?
    let next: String?

    enum CodingKeys: String, CodingKey {
        case country, category, longitude, latitude, maxDistance
        case orderBy = "order_by"
        case limit, next
    }

    init(
        region: String? = nil,
        category: String? = nil,
        longitude: Double? = nil,
        latitude: Double? = nil,
        maxDistance: Double? = nil,
        orderBy: String? = nil,
        limit: Int? = nil,
        cursor: String? = nil
    ) {
        self.country = region
        self.category = category
        self.longitude = longitude
        self.latitude = latitude
        self.maxDistance = maxDistance
        self.orderBy = orderBy
        self.limit = limit
        self.next = cursor
    }
}

/// 게시글 목록 조회 쿼리
struct PostListQuery: Encodable {
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
}
