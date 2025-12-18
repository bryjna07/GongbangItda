//
//  CommentDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 댓글 DTO
struct CommentDTO: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: UserSummaryDTO
    let replies: [ReplyDTO]? // 구조 수정 필요

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
        case replies
    }
}

/// 대댓글 DTO
struct ReplyDTO: Decodable {
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
