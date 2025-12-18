//
//  OrderResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 주문 생성 응답 DTO
struct OrderCreateResponseDTO: Decodable {
    let orderId: String
    let orderCode: String
    let totalPrice: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderCode = "order_code"
        case totalPrice = "total_price"
        case createdAt
        case updatedAt
    }
}

/// 주문 목록 응답 DTO
struct OrderListResponseDTO: Decodable {
    let data: [OrderDTO]
}

/// 주문 항목 DTO
struct OrderDTO: Decodable {
    let orderId: String
    let orderCode: String
    let totalPrice: Int
    let review: ReviewSummaryDTO?
    let reservationItemName: String
    let reservationItemTime: String
    let participantCount: Int
    let activity: GongbangSummaryDTO
    let paidAt: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderCode = "order_code"
        case totalPrice = "total_price"
        case review
        case reservationItemName = "reservation_item_name"
        case reservationItemTime = "reservation_item_time"
        case participantCount = "participant_count"
        case activity
        case paidAt
        case createdAt
        case updatedAt
    }
}
