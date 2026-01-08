//
//  UserRepository.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift
import Alamofire

/// 사용자 데이터 접근 구현
final class UserRepository: UserRepositoryProtocol {

    // MARK: - Properties
    private let networkService: NetworkServiceProtocol

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - UserRepositoryProtocol

    func fetchMyProfile() -> Single<User> {
        return networkService.request(UserRouter.fetchMyProfile)
            .map { (dto: UserProfileResponseDTO) in
                dto.toEntity()
            }
    }

    func updateProfile(
        nickname: String?,
        profileImageURL: String?,
        phoneNumber: String?,
        introduction: String?
    ) -> Single<User> {
        let request = UpdateProfileRequest(
            nickname: nickname,
            profileImageURL: profileImageURL,
            phoneNumber: phoneNumber,
            introduction: introduction
        )

        return networkService.request(UserRouter.updateProfile(request))
            .map { (dto: UserProfileResponseDTO) in
                dto.toEntity()
            }
    }

    func uploadProfileImage(imageData: Data) -> Single<String> {
        return networkService.upload(UserRouter.uploadProfileImage) { multipartFormData in
            multipartFormData.append(
                imageData,
                withName: "profile",
                fileName: "profile.jpg",
                mimeType: "image/jpeg"
            )
        }
        .map { (dto: ProfileImageUploadResponseDTO) in
            dto.profileImage
        }
    }
}
