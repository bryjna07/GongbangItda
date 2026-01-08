//
//  AuthRepositoryProtocol.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import RxSwift

protocol AuthRepositoryProtocol {

    // MARK: - 회원가입/로그인

    /// 회원가입
    /// - Returns: 사용자 정보 + 토큰
    func signUp(
        email: String,
        password: String,
        nickname: String?,
        phoneNum: String?,
        introduction: String?,
        deviceToken: String?
    ) -> Single<AuthResult>

    /// 로그인
    /// - Returns: 사용자 정보 + 토큰
    func login(
        email: String,
        password: String,
        deviceToken: String?
    ) -> Single<AuthResult>

    /// 카카오 로그인
    /// - Parameter oauthToken: 카카오 OAuth 토큰
    /// - Returns: 사용자 정보 + 토큰
    func kakaoLogin(oauthToken: String) -> Single<AuthResult>

    /// 애플 로그인
    /// - Parameter idToken: Apple ID Token
    /// - Returns: 사용자 정보 + 토큰
    func appleLogin(idToken: String) -> Single<AuthResult>

    /// 로그아웃
    /// - Returns: 로그아웃 성공 여부
    func logout() -> Single<Void>

    // MARK: - 이메일 검증

    /// 이메일 유효성 체크
    /// - Returns: 사용 가능 여부 (true: 사용 가능)
    func validateEmail(email: String) -> Single<Bool>

    // MARK: - 토큰 관리

    /// 토큰 갱신
    /// - Returns: 새로운 토큰 쌍
    func refreshToken(
        accessToken: String,
        refreshToken: String
    ) -> Single<TokenPair>
}
