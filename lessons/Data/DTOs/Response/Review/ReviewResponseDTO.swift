//
//  ReviewResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 리뷰 생성 응답 DTO
struct ReviewCreateResponseDTO: Decodable {
    let reviewId: String
    let rating: Int
    let content: String
    let activity: GongbangSummaryDTO
    let reviewImageUrls: [String]
    let reservationItemName: String
    let reservationItemTime: String
    let creator: UserSummaryDTO
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
        case rating
        case content
        case activity
        case reviewImageUrls = "review_image_urls"
        case reservationItemName = "reservation_item_name"
        case reservationItemTime = "reservation_item_time"
        case creator
        case createdAt
        case updatedAt
    }
}
