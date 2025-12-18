//
//  UserSummaryDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 공통으로 사용되는 유저 요약 정보
struct UserSummaryDTO: Decodable {
    let userId: String
    let email: String?
    let nick: String
    let profileImage: String?
    let introduction: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case introduction
    }
}
