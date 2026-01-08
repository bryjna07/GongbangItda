//
//  AuthUseCaseProtocol.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift

/// 인증 관련 비즈니스 로직 인터페이스
protocol AuthUseCaseProtocol {

    // MARK: - 로그인

    /// 이메일 로그인
    /// - Parameters:
    ///   - email: 이메일
    ///   - password: 비밀번호
    ///   - deviceToken: FCM 디바이스 토큰 (선택)
    /// - Returns: 인증 결과
    func login(email: String, password: String, deviceToken: String?) -> Single<AuthResult>

    /// 카카오 로그인
    /// - Parameter accessToken: 카카오 액세스 토큰
    /// - Returns: 인증 결과
    func loginWithKakao(accessToken: String) -> Single<AuthResult>

    /// 애플 로그인
    /// - Parameters:
    ///   - identityToken: Apple Identity Token
    ///   - authorizationCode: Authorization Code
    /// - Returns: 인증 결과
    func loginWithApple(identityToken: String, authorizationCode: String) -> Single<AuthResult>

    // MARK: - 회원가입

    /// 이메일 회원가입
    /// - Parameters:
    ///   - email: 이메일
    ///   - password: 비밀번호
    ///   - nickname: 닉네임
    ///   - phoneNum: 전화번호
    ///   - introduction: 소개
    /// - Returns: 인증 결과
    func signUp(
        email: String,
        password: String,
        nickname: String,
        phoneNum: String,
        introduction: String
    ) -> Single<AuthResult>

    /// 이메일 중복 확인
    /// - Parameter email: 확인할 이메일
    /// - Returns: 사용 가능 여부 (true: 사용 가능)
    func validateEmail(email: String) -> Single<Bool>

    // MARK: - 로그아웃 및 토큰 관리

    /// 로그아웃
    /// - Returns: 성공 여부
    func logout() -> Single<Void>

    /// 토큰 갱신
    /// - Returns: 새로운 인증 결과
    func refreshToken() -> Single<AuthResult>

    // MARK: - 클라이언트 검증

    /// 이메일 형식 검증
    /// - Parameter email: 검증할 이메일
    /// - Returns: 유효성 여부
    func isValidEmailFormat(_ email: String) -> Bool

    /// 비밀번호 강도 검증
    /// - Parameter password: 검증할 비밀번호
    /// - Returns: 유효성 여부 (8자 이상, 영문자/숫자/특수문자 각 1개 이상)
    func isValidPassword(_ password: String) -> Bool

    /// 닉네임 검증
    /// - Parameter nickname: 검증할 닉네임
    /// - Returns: 유효성 여부 (특수문자 제외)
    func isValidNickname(_ nickname: String) -> Bool

    /// 전화번호 검증
    /// - Parameter phoneNum: 검증할 전화번호
    /// - Returns: 유효성 여부 (10-11자리 숫자)
    func isValidPhoneNum(_ phoneNum: String) -> Bool
}
