//
//  InputValidator.swift
//  lessons
//
//  Created by Watson22_YJ on 12/28/25.
//

import Foundation

/// 입력값 검증 유틸리티
/// - Note: AuthUseCase, EditProfileViewController 등에서 공통 사용
enum InputValidator {

    // MARK: - 글자 수 제한

    /// 닉네임 최대 글자 수
    static let nicknameMaxLength = 10
    /// 전화번호 최대 글자 수
    static let phoneNumberMaxLength = 11
    /// 소개 최대 글자 수
    static let introductionMaxLength = 200

    // MARK: - Nickname

    /// 닉네임 검증 결과
    enum NicknameResult {
        case valid
        case empty
        case containsSpecialCharacters

        var errorMessage: String? {
            switch self {
            case .valid: return nil
            case .empty: return "닉네임을 입력해주세요"
            case .containsSpecialCharacters: return "특수문자는 사용할 수 없습니다"
            }
        }

        var isValid: Bool { self == .valid }
    }

    /// 닉네임 검증 (상세)
    static func validateNickname(_ nickname: String?) -> NicknameResult {
        guard let nickname = nickname?.trimmingCharacters(in: .whitespacesAndNewlines),
              !nickname.isEmpty else {
            return .empty
        }

        let invalidChars = CharacterSet(charactersIn: "-.?*-@+^${}()|[]\\")
        if nickname.rangeOfCharacter(from: invalidChars) != nil {
            return .containsSpecialCharacters
        }

        return .valid
    }

    /// 닉네임 검증 (Boolean) - AuthUseCase용
    static func isValidNickname(_ nickname: String) -> Bool {
        validateNickname(nickname).isValid
    }

    // MARK: - Auth (SignUp/Login 전용)

    /// 이메일 형식 검증
    static func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = /[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}/
        return email.wholeMatch(of: emailRegex) != nil
    }

    /// 비밀번호 강도 검증
    /// - Note: 최소 8자 이상, 영문자/숫자/특수문자 각 1개 이상
    static func isValidPassword(_ password: String) -> Bool {
        let hasLetter = password.contains(where: { $0.isLetter })
        let hasNumber = password.contains(where: { $0.isNumber })
        let hasSpecialChar = password.contains(where: { "@$!%*#?&".contains($0) })

        return password.count >= 8 && hasLetter && hasNumber && hasSpecialChar
    }

    /// 전화번호 검증 (10-11자리 숫자)
    static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = /^[0-9]{10,11}$/
        return phoneNumber.wholeMatch(of: phoneRegex) != nil
    }
}
