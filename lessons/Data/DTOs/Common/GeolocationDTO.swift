//
//  GeolocationDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 위치 정보 DTO
struct GeolocationDTO: Decodable {
    let longitude: Double
    let latitude: Double
}
