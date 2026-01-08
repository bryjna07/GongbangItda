//
//  ProfileUseCaseProtocol.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift

/// 프로필 관련 비즈니스 로직 인터페이스
protocol ProfileUseCaseProtocol {

    // MARK: - 프로필 조회

    /// 내 프로필 조회
    /// - Returns: 사용자 정보
    func fetchMyProfile() -> Single<User>

    // MARK: - 프로필 수정

    /// 프로필 수정
    /// - Parameters:
    ///   - nickname: 닉네임 (optional)
    ///   - phoneNumber: 전화번호 (optional)
    ///   - introduction: 소개 (optional)
    ///   - profileImage: 프로필 이미지 데이터 (optional, 업로드 후 URL을 서버에 전송)
    /// - Returns: 수정된 사용자 정보
    func updateProfile(
        nickname: String?,
        phoneNumber: String?,
        introduction: String?,
        profileImage: String?
    ) -> Single<User>

    // MARK: - 프로필 이미지

    /// 프로필 이미지 업로드
    /// - Parameter imageData: 이미지 데이터 (jpg, png, jpeg, 최대 1MB)
    /// - Returns: 업로드된 이미지 URL
    func uploadProfileImage(imageData: Data) -> Single<String>

    // MARK: - 로그아웃

    /// 로그아웃
    /// - Returns: 성공 여부
    func logout() -> Single<Void>
}
