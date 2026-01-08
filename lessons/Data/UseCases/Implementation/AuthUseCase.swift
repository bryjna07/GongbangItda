//
//  AuthUseCase.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift

/// 인증 관련 비즈니스 로직 구현
final class AuthUseCase: AuthUseCaseProtocol {

    // MARK: - Properties
    private let repository: AuthRepositoryProtocol

    // MARK: - Initialization
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - 로그인

    func login(email: String, password: String, deviceToken: String?) -> Single<AuthResult> {
        return repository.login(email: email, password: password, deviceToken: deviceToken)
            .do(onSuccess: { result in
                KeychainManager.saveAccessToken(result.accessToken)
                KeychainManager.saveRefreshToken(result.refreshToken)
                Log.info("로그인 성공 - userId: \(result.user.id)")
            })
    }

    func loginWithKakao(accessToken: String) -> Single<AuthResult> {
        return repository.kakaoLogin(oauthToken: accessToken)
            .do(onSuccess: { result in
                KeychainManager.saveAccessToken(result.accessToken)
                KeychainManager.saveRefreshToken(result.refreshToken)
                Log.info("카카오 로그인 성공 - userId: \(result.user.id), nickname: \(result.user.nickname)")
            })
    }

    func loginWithApple(identityToken: String, authorizationCode: String) -> Single<AuthResult> {
        return repository.appleLogin(idToken: identityToken)
            .do(onSuccess: { result in
                KeychainManager.saveAccessToken(result.accessToken)
                KeychainManager.saveRefreshToken(result.refreshToken)
                Log.info("애플 로그인 성공 - userId: \(result.user.id), nickname: \(result.user.nickname)")
            })
    }

    // MARK: - 회원가입

    func signUp(
        email: String,
        password: String,
        nickname: String,
        phoneNum: String,
        introduction: String
    ) -> Single<AuthResult> {
        return repository.signUp(
            email: email,
            password: password,
            nickname: nickname,
            phoneNum: phoneNum.isEmpty ? nil : phoneNum,
            introduction: introduction.isEmpty ? nil : introduction,
            deviceToken: nil
        )
        .do(onSuccess: { result in
            KeychainManager.saveAccessToken(result.accessToken)
            KeychainManager.saveRefreshToken(result.refreshToken)
            Log.info("회원가입 성공 - userId: \(result.user.id)")
        })
    }

    func validateEmail(email: String) -> Single<Bool> {
        return repository.validateEmail(email: email)
    }

    // MARK: - 로그아웃 및 토큰 관리

    func logout() -> Single<Void> {
        return repository.logout()
            .do(onSuccess: {
                KeychainManager.deleteAll()
                Log.info("로그아웃 완료")
            })
    }

    func refreshToken() -> Single<AuthResult> {
        guard let accessToken = KeychainManager.loadAccessToken(),
              let refreshToken = KeychainManager.loadRefreshToken() else {
            return .error(AuthError.tokenNotFound)
        }

        return repository.refreshToken(accessToken: accessToken, refreshToken: refreshToken)
            .map { tokenPair in
                KeychainManager.saveAccessToken(tokenPair.accessToken)
                KeychainManager.saveRefreshToken(tokenPair.refreshToken)

                // AuthResult로 변환 (User 정보는 기존 것 사용)
                // TODO: 필요시 User 정보도 함께 갱신
                return AuthResult(
                    user: User(id: "", email: "", nickname: "", profileImageURL: nil, phoneNumber: nil, introduction: nil),
                    accessToken: tokenPair.accessToken,
                    refreshToken: tokenPair.refreshToken
                )
            }
    }

    // MARK: - 클라이언트 검증 (InputValidator 위임)

    func isValidEmailFormat(_ email: String) -> Bool {
        InputValidator.isValidEmailFormat(email)
    }

    func isValidPassword(_ password: String) -> Bool {
        InputValidator.isValidPassword(password)
    }

    func isValidNickname(_ nickname: String) -> Bool {
        InputValidator.isValidNickname(nickname)
    }

    func isValidPhoneNum(_ phoneNum: String) -> Bool {
        InputValidator.isValidPhoneNumber(phoneNum)
    }
}
