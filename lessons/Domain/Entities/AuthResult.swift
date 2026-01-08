//
//  AuthResult.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 인증 결과 (로그인/회원가입)
struct AuthResult: Equatable {

    /// 사용자 정보
    let user: User

    /// 액세스 토큰
    let accessToken: String

    /// 리프레시 토큰
    let refreshToken: String
}

/// 토큰 쌍
struct TokenPair: Equatable {

    /// 액세스 토큰
    let accessToken: String

    /// 리프레시 토큰
    let refreshToken: String
}
