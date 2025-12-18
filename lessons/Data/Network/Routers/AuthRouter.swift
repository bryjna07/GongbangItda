//
//  AuthRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 인증 관련 API Router
enum AuthRouter {
    /// 이메일 중복 확인
    case validateEmail(EmailValidationRequest)

    /// 회원가입
    case signUp(SignUpRequest)

    /// 이메일 로그인
    case login(LoginRequest)

    /// 카카오 로그인
    case kakaoLogin(KakaoLoginRequest)

    /// 애플 로그인
    case appleLogin(AppleLoginRequest)

    /// 토큰 갱신 (AuthInterceptor에서 사용)
    case refreshToken(accessToken: String, refreshToken: String)

    /// 로그아웃
    case logout

    /// 디바이스 토큰 업데이트
    case updateDeviceToken(DeviceTokenRequest)

    /// 회원 탈퇴
    case withdraw
}

// MARK: - Router

extension AuthRouter: Router {

    var path: String {
        switch self {
        case .validateEmail:
            return "/v1/users/validation/email"
        case .signUp:
            return "/v1/users/join"
        case .login:
            return "/v1/users/login"
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .appleLogin:
            return "/v1/users/login/apple"
        case .refreshToken:
            return "/v1/auth/refresh"
        case .logout:
            return "/v1/users/logout"
        case .updateDeviceToken:
            return "/v1/users/deviceToken"
        case .withdraw:
            return "/v1/users/withdraw"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .validateEmail, .signUp, .login, .kakaoLogin, .appleLogin, .logout:
            return .post
        case .refreshToken:
            return .get
        case .updateDeviceToken:
            return .put
        case .withdraw:
            return .delete
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .refreshToken(let accessToken, let refreshToken):
            return HTTPHeaders([
                .contentType,
                .apiKey,
                .authorization(accessToken),
                .refreshToken(refreshToken)
            ])
        default:
            return HTTPHeaders([
                .contentType,
                .apiKey
            ])
        }
    }

    var parameters: Parameters? {
        switch self {
        case .validateEmail(let request):
            return request.toDictionary()

        case .signUp(let request):
            return request.toDictionary()

        case .login(let request):
            return request.toDictionary()

        case .kakaoLogin(let request):
            return request.toDictionary()

        case .appleLogin(let request):
            return request.toDictionary()

        case .updateDeviceToken(let request):
            return request.toDictionary()

        case .refreshToken, .logout, .withdraw:
            return nil
        }
    }
}

// MARK: - Request Models

/// 이메일 중복 확인 요청
struct EmailValidationRequest: Encodable {
    let email: String
}

/// 회원가입 요청
struct SignUpRequest: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let introduction: String?
    let deviceToken: String?

    init(
        email: String,
        password: String,
        nickname: String,
        phoneNum: String? = nil,
        introduction: String? = nil,
        deviceToken: String? = nil
    ) {
        self.email = email
        self.password = password
        self.nick = nickname
        self.phoneNum = phoneNum
        self.introduction = introduction
        self.deviceToken = deviceToken
    }
}

/// 이메일 로그인 요청
struct LoginRequest: Encodable {
    let email: String
    let password: String
    let deviceToken: String?

    init(email: String, password: String, deviceToken: String? = nil) {
        self.email = email
        self.password = password
        self.deviceToken = deviceToken
    }
}

/// 카카오 로그인 요청
struct KakaoLoginRequest: Encodable {
    let oauthToken: String
    let deviceToken: String?

    init(oauthToken: String, deviceToken: String? = nil) {
        self.oauthToken = oauthToken
        self.deviceToken = deviceToken
    }
}

/// 애플 로그인 요청
struct AppleLoginRequest: Encodable {
    let idToken: String
    let deviceToken: String?

    init(idToken: String, deviceToken: String? = nil) {
        self.idToken = idToken
        self.deviceToken = deviceToken
    }
}

/// 디바이스 토큰 업데이트 요청
struct DeviceTokenRequest: Encodable {
    let deviceToken: String
}

// MARK: - Encodable to Dictionary

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
