//
//  ReviewListResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 리뷰 목록 응답 DTO
struct ReviewListResponseDTO: Decodable {
    let data: [ReviewDTO]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

/// 리뷰 항목 DTO
struct ReviewDTO: Decodable {
    let reviewId: String
    let content: String
    let rating: Int
    let reviewImageUrls: [String]
    let reservationItemName: String
    let reservationItemTime: String
    let creator: UserSummaryDTO
    let userTotalReviewCount: Int?
    let userTotalRating: Double?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
        case content
        case rating
        case reviewImageUrls = "review_image_urls"
        case reservationItemName = "reservation_item_name"
        case reservationItemTime = "reservation_item_time"
        case creator
        case userTotalReviewCount = "user_total_review_count"
        case userTotalRating = "user_total_rating"
        case createdAt
        case updatedAt
    }
}
