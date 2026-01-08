//
//  AuthError.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation

/// 인증 관련 에러 타입
enum AuthError: Error, Equatable {

    // MARK: - Token Errors

    case tokenNotFound
    case tokenExpired
    case invalidToken

    // MARK: - Validation Errors

    case invalidEmailFormat
    case invalidPassword
    case invalidNickname
    case invalidPhoneNumber
    case emailAlreadyExists

    // MARK: - Authentication Errors

    case loginFailed
    case signUpFailed
    case logoutFailed
    case refreshFailed

    // MARK: - Network Errors

    case networkError(NetworkError)

    // MARK: - Unknown

    case unknown
}

// MARK: - LocalizedError

extension AuthError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .tokenNotFound:
            return "저장된 토큰이 없습니다. 다시 로그인해주세요."
        case .tokenExpired:
            return "로그인이 만료되었습니다. 다시 로그인해주세요."
        case .invalidToken:
            return "유효하지 않은 토큰입니다. 다시 로그인해주세요."

        case .invalidEmailFormat:
            return "올바른 이메일 형식이 아닙니다."
        case .invalidPassword:
            return "비밀번호는 8자 이상, 영문자/숫자/특수문자를 각 1개 이상 포함해야 합니다."
        case .invalidNickname:
            return "닉네임에는 특수문자를 사용할 수 없습니다."
        case .invalidPhoneNumber:
            return "전화번호는 10-11자리 숫자여야 합니다."
        case .emailAlreadyExists:
            return "이미 사용 중인 이메일입니다."

        case .loginFailed:
            return "로그인에 실패했습니다."
        case .signUpFailed:
            return "회원가입에 실패했습니다."
        case .logoutFailed:
            return "로그아웃에 실패했습니다."
        case .refreshFailed:
            return "토큰 갱신에 실패했습니다."

        case .networkError(let networkError):
            return networkError.localizedDescription

        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
