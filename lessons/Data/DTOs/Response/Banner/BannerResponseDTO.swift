//
//  BannerResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

// MARK: - Banner List Response
struct BannerListResponseDTO: Decodable {
    let data: [BannerDTO]
}

// MARK: - Banner DTO
struct BannerDTO: Decodable {
    let name: String
    let imageUrl: String
    let payload: BannerPayloadDTO

    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl
        case payload
    }
}

// MARK: - Banner Payload DTO
struct BannerPayloadDTO: Decodable {
    let type: String
    let value: String
}
