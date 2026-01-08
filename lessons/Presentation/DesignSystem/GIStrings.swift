//
//  GIStrings.swift
//  lessons
//
//  Created by Watson22_YJ on 12/29/25.
//

import Foundation

/// 디자인 시스템 문자열 상수
enum GIStrings {

    // MARK: - Common

    enum Common {
        static let confirm = "확인"
        static let cancel = "취소"
        static let save = "저장"
        static let edit = "수정"
        static let delete = "삭제"
        static let close = "닫기"
        static let done = "완료"
        static let next = "다음"
        static let back = "뒤로"
        static let error = "오류"
        static let alert = "알림"
    }

    // MARK: - Auth

    enum Auth {
        static let login = "로그인"
        static let logout = "로그아웃"
        static let signUp = "회원가입"
        static let signUpWithEmail = "이메일로 회원가입"
        static let emailLogin = "이메일로 로그인"
        static let emailCheckDuplicate = "중복확인"

        enum Placeholder {
            static let email = "이메일"
            static let emailInput = "이메일을 입력하세요"
            static let password = "비밀번호"
            static let passwordInput = "비밀번호를 입력하세요"
            static let passwordWithHint = "비밀번호 (8자 이상)"
            static let nickname = "닉네임"
            static let phoneNumber = "01012345678"
            static let phoneNumberOptional = "전화번호 (선택)"
            static let introduction = "간단한 자기소개를 입력해주세요"
            static let introductionOptional = "소개 (선택)"
        }

        enum Validation {
            static let emailInvalid = "올바른 이메일 형식이 아닙니다"
            static let emailAvailable = "사용 가능한 이메일입니다"
            static let passwordTooShort = "비밀번호는 8자 이상이어야 합니다"
            static let nicknameSpecialChar = "특수문자는 사용할 수 없습니다"
            static let phoneNumberInvalid = "올바른 전화번호 형식이 아닙니다 (10-11자리)"
        }

        enum SectionLabel {
            static let email = "이메일"
            static let password = "비밀번호"
            static let nickname = "닉네임"
            static let phoneNumber = "전화번호"
            static let introduction = "소개"
        }
    }

    // MARK: - Profile

    enum Profile {
        static let title = "프로필"
        static let editTitle = "프로필 수정"
        static let defaultNickname = "씩씩한 새싹이"
        // TODO: - 서버 연동 후 수정
        static let defaultIntroduction = "액티비티를 즐기고 기록하는 것을 좋아하는 새싹이입니다."
        static let logoutConfirmTitle = "로그아웃"
        static let logoutConfirmMessage = "로그아웃 하시겠습니까?"
        static let imageCompressionError = "이미지 압축에 실패했습니다."

        enum Stats {
            static let totalAmountTitle = "총 사용 금액"
            static let totalPointsTitle = "누적 적립 포인트"
            // TODO: - 서버 연동 후 수정
            static let defaultAmount = "0원"
            static let defaultPoints = "0P"
        }

        // TODO: - 서버 연동 후 수정
        enum Category {
            static let first = "1위 투어"
            static let second = "2위 액티비티"
            static let third = "3위 체험"
        }
    }

    // MARK: - TabBar

    enum TabBar {
        static let home = "홈"
        static let search = "검색"
        static let bookmark = "북마크"
        static let profile = "프로필"
    }
}
