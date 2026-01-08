//
//  ProfileUseCase.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift

/// 프로필 비즈니스 로직 구현
final class ProfileUseCase: ProfileUseCaseProtocol {

    // MARK: - Properties
    private let userRepository: UserRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Initialization
    init(userRepository: UserRepositoryProtocol, authRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }

    // MARK: - ProfileUseCaseProtocol

    func fetchMyProfile() -> Single<User> {
        return userRepository.fetchMyProfile()
            .do(onSuccess: { user in
                Log.info("프로필 조회 성공 - userId: \(user.id)")
            })
    }

    func updateProfile(
        nickname: String?,
        phoneNumber: String?,
        introduction: String?,
        profileImage: String?
    ) -> Single<User> {
        // 프로필 정보 수정 (이미지는 별도로 업로드되므로 profileImageURL은 nil)
        return userRepository.updateProfile(
            nickname: nickname,
            profileImageURL: profileImage,
            phoneNumber: phoneNumber,
            introduction: introduction
        )
        .do(onSuccess: { user in
            Log.info("프로필 수정 성공 - userId: \(user.id)")
        })
    }

    func uploadProfileImage(imageData: Data) -> Single<String> {
        Log.info("프로필 이미지 업로드 시작 - 크기: \(imageData.count) bytes")

        return userRepository.uploadProfileImage(imageData: imageData)
            .do(onSuccess: { imageURL in
                Log.info("프로필 이미지 업로드 성공 - URL: \(imageURL)")
            })
    }

    func logout() -> Single<Void> {
        return authRepository.logout()
            .do(onSuccess: {
                // Keychain에서 토큰 삭제
                KeychainManager.deleteAll()
                Log.info("로그아웃 완료")
            })
    }
}
