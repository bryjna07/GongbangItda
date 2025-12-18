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
