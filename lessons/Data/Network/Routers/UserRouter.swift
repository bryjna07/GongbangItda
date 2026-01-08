//
//  UserRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 사용자 관련 API Router
enum UserRouter {
    /// 내 프로필 조회
    case fetchMyProfile

    /// 프로필 수정
    case updateProfile(UpdateProfileRequest)

    /// 프로필 이미지 업로드
    case uploadProfileImage

    /// 유저 검색
    case searchUsers(nickname: String)

    /// 다른 유저 프로필 조회
    case fetchUserProfile(userId: String)
}

// MARK: - Router

extension UserRouter: Router {

    var path: String {
        switch self {
        case .fetchMyProfile, .updateProfile:
            return "/v1/users/me/profile"
        case .uploadProfileImage:
            return "/v1/users/profile/image"
        case .searchUsers:
            return "/v1/users/search"
        case .fetchUserProfile(let userId):
            return "/v1/users/\(userId)/profile"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMyProfile, .searchUsers, .fetchUserProfile:
            return .get
        case .updateProfile:
            return .put
        case .uploadProfileImage:
            return .post
        }
    }

    var isMultipartUpload: Bool {
        switch self {
        case .uploadProfileImage:
            return true
        default:
            return false
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchMyProfile:
            return nil

        case .updateProfile(let request):
            return request.toDictionary()

        case .uploadProfileImage:
            return nil

        case .searchUsers(let nickname):
            return ["nick": nickname]

        case .fetchUserProfile:
            return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .searchUsers:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}

// MARK: - Request Models

/// 프로필 수정 요청
struct UpdateProfileRequest: Encodable {
    let nick: String?
    let profileImage: String?
    let phoneNum: String?
    let introduction: String?

    init(
        nickname: String? = nil,
        profileImageURL: String? = nil,
        phoneNumber: String? = nil,
        introduction: String? = nil
    ) {
        self.nick = nickname
        self.profileImage = profileImageURL
        self.phoneNum = phoneNumber
        self.introduction = introduction
    }
}
