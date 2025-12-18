//
//  RestrictionsDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 공방 참여 제한사항 DTO
/// 0이 아닌 양수값
struct RestrictionsDTO: Decodable {
    let minHeight: Int? // 성별제한으로 사용 1 남자 2 여자 3 무관
    let minAge: Int?
    let maxParticipants: Int

    enum CodingKeys: String, CodingKey {
        case minHeight = "min_height"
        case minAge = "min_age"
        case maxParticipants = "max_participants"
    }
}
