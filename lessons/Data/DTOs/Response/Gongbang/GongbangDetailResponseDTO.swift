//
//  GongbangDetailResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 공방 상세 응답 DTO
struct GongbangDetailResponseDTO: Decodable {
    let activityId: String
    let title: String
    let country: String
    let category: String
    let thumbnails: [String]
    let geolocation: GeolocationDTO
    let startDate: String
    let endDate: String
    let price: PriceDTO
    let tags: [String]
    let pointReward: Int
    let restrictions: RestrictionsDTO
    let description: String
    let isAdvertisement: Bool
    let isKeep: Bool
    let keepCount: Int
    let totalOrderCount: Int
    let schedule: [ScheduleDTO]
    let reservationList: [ReservationItemDTO]
    let creator: UserSummaryDTO
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case activityId = "activity_id"
        case title
        case country
        case category
        case thumbnails
        case geolocation
        case startDate = "start_date"
        case endDate = "end_date"
        case price
        case tags
        case pointReward = "point_reward"
        case restrictions
        case description
        case isAdvertisement = "is_advertisement"
        case isKeep = "is_keep"
        case keepCount = "keep_count"
        case totalOrderCount = "total_order_count"
        case schedule
        case reservationList = "reservation_list"
        case creator
        case createdAt
        case updatedAt
    }
}
