//
//  ReviewDetailResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 리뷰 상세 응답 DTO
struct ReviewDetailResponseDTO: Decodable {
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

/// 리뷰 평점 통계 응답 DTO
struct ReviewRatingCountResponseDTO: Decodable {
    let data: [RatingCountDTO]
}

/// 평점별 개수 DTO
struct RatingCountDTO: Decodable {
    let rating: Int
    let count: Int
}
