//
//  UserRepositoryProtocol.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import RxSwift

/// 사용자 데이터 접근 Repository Protocol
/// - Domain Layer에서 정의
/// - Data Layer에서 구현 (UserRepository)
protocol UserRepositoryProtocol {

    // MARK: - 프로필 조회/수정

    /// 내 프로필 조회
    /// - Returns: 사용자 정보
    func fetchMyProfile() -> Single<User>

    /// 프로필 수정
    /// - Parameters:
    ///   - nickname: 닉네임 (optional)
    ///   - profileImageURL: 프로필 이미지 URL (optional, 이미지 업로드 후 받은 경로)
    ///   - phoneNumber: 전화번호 (optional)
    ///   - introduction: 소개 (optional)
    /// - Returns: 수정된 사용자 정보
    func updateProfile(
        nickname: String?,
        profileImageURL: String?,
        phoneNumber: String?,
        introduction: String?
    ) -> Single<User>

    // MARK: - 이미지 업로드

    /// 프로필 이미지 업로드
    /// - Parameter imageData: 이미지 데이터
    /// - Returns: 파일 ID
    func uploadProfileImage(imageData: Data) -> Single<String>
}
