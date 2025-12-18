//
//  GongbangSummaryDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 공방 요약 정보 DTO (다른 리소스에 포함되는 공방 정보)
struct GongbangSummaryDTO: Decodable {
    let id: String
    let title: String
    let country: String
    let category: String
    let thumbnails: [String]
    let geolocation: GeolocationDTO
    let price: PriceDTO
    let tags: [String]
    let pointReward: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case country
        case category
        case thumbnails
        case geolocation
        case price
        case tags
        case pointReward = "point_reward"
    }
}
