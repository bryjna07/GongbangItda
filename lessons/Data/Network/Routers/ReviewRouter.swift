//
//  ReviewRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 리뷰 API Router
enum ReviewRouter {
    /// 리뷰 이미지 업로드
    case uploadFiles(gongbangId: String)

    /// 리뷰 작성
    case create(gongbangId: String, CreateReviewRequest)

    /// 공방별 리뷰 목록 조회
    case fetchList(gongbangId: String, ReviewListQuery)

    /// 리뷰 상세 조회
    case fetchDetail(gongbangId: String, reviewId: String)

    /// 리뷰 수정
    case update(gongbangId: String, reviewId: String, UpdateReviewRequest)

    /// 리뷰 삭제
    case delete(gongbangId: String, reviewId: String)

    /// 별점별 리뷰 개수 조회
    case fetchRatingCount(gongbangId: String)

    /// 유저별 리뷰 목록 조회
    case fetchUserReviews(userId: String, UserReviewListQuery)
}

// MARK: - Router

extension ReviewRouter: Router {

    var path: String {
        switch self {
        case .uploadFiles(let gongbangId):
            return "/v1/activities/\(gongbangId)/reviews/files"
        case .create(let gongbangId, _):
            return "/v1/activities/\(gongbangId)/reviews"
        case .fetchList(let gongbangId, _):
            return "/v1/activities/\(gongbangId)/reviews"
        case .fetchDetail(let gongbangId, let reviewId):
            return "/v1/activities/\(gongbangId)/reviews/\(reviewId)"
        case .update(let gongbangId, let reviewId, _):
            return "/v1/activities/\(gongbangId)/reviews/\(reviewId)"
        case .delete(let gongbangId, let reviewId):
            return "/v1/activities/\(gongbangId)/reviews/\(reviewId)"
        case .fetchRatingCount(let gongbangId):
            return "/v1/activities/\(gongbangId)/reviews/rating-count"
        case .fetchUserReviews(let userId, _):
            return "/v1/activities/reviews/users/\(userId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .uploadFiles, .create:
            return .post
        case .fetchList, .fetchDetail, .fetchRatingCount, .fetchUserReviews:
            return .get
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case .uploadFiles:
            return nil

        case .create(_, let request):
            return request.toDictionary()

        case .fetchList(_, let query):
            return query.toDictionary()

        case .fetchDetail:
            return nil

        case .update(_, _, let request):
            return request.toDictionary()

        case .delete:
            return nil

        case .fetchRatingCount:
            return nil

        case .fetchUserReviews(_, let query):
            return query.toDictionary()
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .fetchList, .fetchUserReviews:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}

// MARK: - Request Models

/// 리뷰 작성 요청
struct CreateReviewRequest: Encodable {
    let orderId: String
    let rating: Int
    let content: String
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case rating, content, files
    }

    init(orderId: String, rating: Int, content: String, imageURLs: [String]) {
        self.orderId = orderId
        self.rating = rating
        self.content = content
        self.files = imageURLs
    }
}

/// 리뷰 수정 요청
struct UpdateReviewRequest: Encodable {
    let rating: Int?
    let content: String?
    let files: [String]?

    init(rating: Int? = nil, content: String? = nil, imageURLs: [String]? = nil) {
        self.rating = rating
        self.content = content
        self.files = imageURLs
    }
}

/// 리뷰 목록 조회 쿼리
struct ReviewListQuery: Encodable {
    let orderBy: String?
    let limit: Int?
    let next: String?

    enum CodingKeys: String, CodingKey {
        case orderBy = "order_by"
        case limit, next
    }

    init(orderBy: String? = nil, limit: Int? = nil, cursor: String? = nil) {
        self.orderBy = orderBy
        self.limit = limit
        self.next = cursor
    }
}

/// 유저 리뷰 목록 조회 쿼리
struct UserReviewListQuery: Encodable {
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
