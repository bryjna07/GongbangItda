//
//  CommentResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 댓글 응답 DTO
struct CommentResponseDTO: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserSummaryDTO

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}
