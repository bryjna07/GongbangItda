//
//  User.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 사용자 도메인 모델
struct User: Equatable {

    // MARK: - 기본 정보

    let id: String
    let email: String
    let nickname: String

    // MARK: - 추가 정보

    let profileImageURL: String?
    let phoneNumber: String?
    let introduction: String?
}

// MARK: - Computed Properties

extension User {

    /// 프로필 이미지 존재 여부
    var hasProfileImage: Bool {
        profileImageURL != nil && !(profileImageURL?.isEmpty ?? true)
    }
}
