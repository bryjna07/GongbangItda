//
//  ReservationDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 예약 아이템 DTO
struct ReservationItemDTO: Decodable {
    let itemName: String
    let times: [ReservationTimeDTO]

    enum CodingKeys: String, CodingKey {
        case itemName = "item_name"
        case times
    }
}

/// 예약 시간 DTO
struct ReservationTimeDTO: Decodable {
    let time: String
    let isReserved: Bool

    enum CodingKeys: String, CodingKey {
        case time
        case isReserved = "is_reserved"
    }
}
