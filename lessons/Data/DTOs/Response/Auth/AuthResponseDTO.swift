//
//  AuthResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

// MARK: - Sign Up Response

/// 회원가입 응답 DTO
struct SignUpResponseDTO: Decodable {
    let user: UserSummaryDTO
    let tokens: TokenPairDTO

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case introduction
        case accessToken
        case refreshToken
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // UserSummaryDTO 구성
        self.user = UserSummaryDTO(
            userId: try container.decode(String.self, forKey: .userId),
            email: try container.decodeIfPresent(String.self, forKey: .email),
            nick: try container.decode(String.self, forKey: .nick),
            profileImage: try container.decodeIfPresent(String.self, forKey: .profileImage),
            introduction: try container.decodeIfPresent(String.self, forKey: .introduction)
        )

        // TokenPairDTO 구성
        self.tokens = TokenPairDTO(
            accessToken: try container.decode(String.self, forKey: .accessToken),
            refreshToken: try container.decode(String.self, forKey: .refreshToken)
        )
    }
}

// MARK: - Login Response

/// 로그인 응답 DTO
struct LoginResponseDTO: Decodable {
    let user: UserSummaryDTO
    let tokens: TokenPairDTO

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case introduction
        case accessToken
        case refreshToken
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // UserSummaryDTO 구성
        self.user = UserSummaryDTO(
            userId: try container.decode(String.self, forKey: .userId),
            email: try container.decode(String.self, forKey: .email),
            nick: try container.decode(String.self, forKey: .nick),
            profileImage: try container.decodeIfPresent(String.self, forKey: .profileImage),
            introduction: try container.decodeIfPresent(String.self, forKey: .introduction)
        )

        // TokenPairDTO 구성
        self.tokens = TokenPairDTO(
            accessToken: try container.decode(String.self, forKey: .accessToken),
            refreshToken: try container.decode(String.self, forKey: .refreshToken)
        )
    }
}
