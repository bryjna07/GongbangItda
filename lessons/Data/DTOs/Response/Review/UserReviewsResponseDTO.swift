//
//  UserReviewsResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 사용자 리뷰 목록 응답 DTO
struct UserReviewsResponseDTO: Decodable {
    let data: [UserReviewDTO]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

/// 사용자 리뷰 항목 DTO
struct UserReviewDTO: Decodable {
    let reviewId: String
    let content: String
    let rating: Int
    let activity: GongbangSummaryDTO
    let reviewImageUrls: [String]
    let reservationItemName: String
    let reservationItemTime: String
    let creator: UserSummaryDTO
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
        case content
        case rating
        case activity
        case reviewImageUrls = "review_image_urls"
        case reservationItemName = "reservation_item_name"
        case reservationItemTime = "reservation_item_time"
        case creator
        case createdAt
        case updatedAt
    }
}
