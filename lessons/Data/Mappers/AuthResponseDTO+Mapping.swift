//
//  AuthResponseDTO+Mapping.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation

// MARK: - SignUpResponseDTO → Entity

extension SignUpResponseDTO {
    /// DTO → AuthResult Entity 변환
    func toEntity() -> AuthResult {
        return AuthResult(
            user: user.toEntity(),
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken
        )
    }
}

// MARK: - LoginResponseDTO → Entity

extension LoginResponseDTO {
    /// DTO → AuthResult Entity 변환
    func toEntity() -> AuthResult {
        return AuthResult(
            user: user.toEntity(),
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken
        )
    }
}

// MARK: - UserSummaryDTO → Entity

extension UserSummaryDTO {
    /// DTO → User Entity 변환
    func toEntity() -> User {
        return User(
            id: userId,
            email: email ?? "",
            nickname: nick,
            profileImageURL: profileImage,
            phoneNumber: nil,  // 응답에 phoneNum이 없으므로 nil
            introduction: introduction
        )
    }
}

// MARK: - TokenPairDTO → Entity

extension TokenPairDTO {
    /// DTO → TokenPair Entity 변환
    func toEntity() -> TokenPair {
        return TokenPair(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
