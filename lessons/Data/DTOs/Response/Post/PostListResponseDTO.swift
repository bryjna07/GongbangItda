//
//  PostListResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 게시글 목록 응답 DTO
struct PostListResponseDTO: Decodable {
    let data: [PostSummaryDTO]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

/// 게시글 요약 DTO (목록용)
struct PostSummaryDTO: Decodable {
    let postId: String
    let country: String
    let category: String
    let title: String
    let content: String
    let activity: GongbangSummaryDTO?
    let geolocation: GeolocationDTO
    let creator: UserSummaryDTO
    let files: [String]
    let isLike: Bool
    let likeCount: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case country
        case category
        case title
        case content
        case activity
        case geolocation
        case creator
        case files
        case isLike = "is_like"
        case likeCount = "like_count"
        case createdAt
        case updatedAt
    }
}
