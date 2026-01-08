//
//  AuthRepository.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift
import Alamofire

/// 인증 데이터 접근 구현
final class AuthRepository: AuthRepositoryProtocol {

    // MARK: - Properties
    private let networkService: NetworkServiceProtocol

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Methods

    func validateEmail(email: String) -> Single<Bool> {
        let request = EmailValidationRequest(email: email)
        return networkService.request(AuthRouter.validateEmail(request))
            .map { (response: MessageResponseDTO) in
                return true  // 200 OK면 사용 가능
            }
            .catch { error in
                // 409 Conflict면 사용 불가
                if let afError = error.asAFError,
                   case .responseValidationFailed(reason: .unacceptableStatusCode(code: 409)) = afError {
                    return .just(false)
                }
                return .error(error)
            }
    }

    func signUp(
        email: String,
        password: String,
        nickname: String?,
        phoneNum: String?,
        introduction: String?,
        deviceToken: String?
    ) -> Single<AuthResult> {
        let request = SignUpRequest(
            email: email,
            password: password,
            nickname: nickname ?? "",
            phoneNum: phoneNum,
            introduction: introduction,
            deviceToken: deviceToken
        )

        return networkService.request(AuthRouter.signUp(request))
            .map { (dto: SignUpResponseDTO) in
                dto.toEntity()
            }
    }

    func login(email: String, password: String, deviceToken: String?) -> Single<AuthResult> {
        let request = LoginRequest(
            email: email,
            password: password,
            deviceToken: deviceToken
        )

        return networkService.request(AuthRouter.login(request))
            .map { (dto: LoginResponseDTO) in
                dto.toEntity()
            }
    }

    func kakaoLogin(oauthToken: String) -> Single<AuthResult> {
        let request = KakaoLoginRequest(
            oauthToken: oauthToken,
            deviceToken: nil
        )

        return networkService.request(AuthRouter.kakaoLogin(request))
            .map { (dto: LoginResponseDTO) in
                dto.toEntity()
            }
    }

    func appleLogin(idToken: String) -> Single<AuthResult> {
        let request = AppleLoginRequest(
            idToken: idToken,
            deviceToken: nil
        )

        return networkService.request(AuthRouter.appleLogin(request))
            .map { (dto: LoginResponseDTO) in
                dto.toEntity()
            }
    }

    func logout() -> Single<Void> {
        return networkService.requestWithoutResponse(AuthRouter.logout)
    }

    func refreshToken(accessToken: String, refreshToken: String) -> Single<TokenPair> {
        return networkService.request(AuthRouter.refreshToken(accessToken: accessToken, refreshToken: refreshToken))
            .map { (dto: TokenPairDTO) in
                dto.toEntity()
            }
    }
}

/// 빈 응답용
struct EmptyResponse: Decodable {}
