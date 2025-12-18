//
//  PostDetailResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 게시글 상세 응답 DTO
struct PostDetailResponseDTO: Decodable {
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
    let comments: [CommentDTO]
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
        case comments
        case createdAt
        case updatedAt
    }
}
