//
//  TokenPairDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 토큰 쌍 DTO
struct TokenPairDTO: Decodable {
    let accessToken: String
    let refreshToken: String

    // MARK: - Initialization

    /// Memberwise initializer
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
