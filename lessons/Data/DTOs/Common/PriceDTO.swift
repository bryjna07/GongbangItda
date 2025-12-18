//
//  PriceDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 가격 정보 DTO
struct PriceDTO: Decodable {
    let original: Int
    let final: Int?
}
