//
//  CommentRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 댓글 API Router
enum CommentRouter {
    /// 댓글 작성
    case create(postId: String, CreateCommentRequest)

    /// 댓글 수정
    case update(postId: String, commentId: String, UpdateCommentRequest)

    /// 댓글 삭제
    case delete(postId: String, commentId: String)
}

// MARK: - Router

extension CommentRouter: Router {

    var path: String {
        switch self {
        case .create(let postId, _):
            return "/v1/posts/\(postId)/comments"
        case .update(let postId, let commentId, _):
            return "/v1/posts/\(postId)/comments/\(commentId)"
        case .delete(let postId, let commentId):
            return "/v1/posts/\(postId)/comments/\(commentId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case .create(_, let request):
            return request.toDictionary()
        case .update(_, _, let request):
            return request.toDictionary()
        case .delete:
            return nil
        }
    }
}

// MARK: - Request Models

/// 댓글 작성 요청
struct CreateCommentRequest: Encodable {
    let content: String
    let parentCommentId: String?

    enum CodingKeys: String, CodingKey {
        case content
        case parentCommentId = "parent_comment_id"
    }

    init(content: String, parentCommentId: String? = nil) {
        self.content = content
        self.parentCommentId = parentCommentId
    }
}

/// 댓글 수정 요청
struct UpdateCommentRequest: Encodable {
    let content: String
}
