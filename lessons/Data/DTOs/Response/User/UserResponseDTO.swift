//
//  UserResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

// MARK: - User Profile Response
struct UserProfileResponseDTO: Decodable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    let phoneNum: String?
    let introduction: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case phoneNum
        case introduction
    }
}

// MARK: - Profile Image Upload Response
struct ProfileImageUploadResponseDTO: Decodable {
    let profileImage: String
}

// MARK: - User Search Response
struct UserSearchResponseDTO: Decodable {
    let data: [UserSearchResultDTO]
}

// MARK: - User Search Result DTO
struct UserSearchResultDTO: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    let introduction: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
        case introduction
    }
}

// MARK: - DTO → Entity Mapping

extension UserProfileResponseDTO {
    func toEntity() -> User {
        return User(
            id: userId,
            email: email,
            nickname: nick,
            profileImageURL: profileImage,
            phoneNumber: phoneNum,
            introduction: introduction
        )
    }
}

extension UserSearchResultDTO {
    func toEntity() -> User {
        return User(
            id: userId,
            email: "", // 검색 결과에는 email 없음
            nickname: nick,
            profileImageURL: profileImage,
            phoneNumber: nil,
            introduction: introduction
        )
    }
}
