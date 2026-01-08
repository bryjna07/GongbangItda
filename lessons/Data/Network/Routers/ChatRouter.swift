//
//  ChatRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 채팅 API Router
enum ChatRouter {
    /// 채팅방 생성 또는 조회
    case createOrFetchRoom(CreateChatRoomRequest)

    /// 내 채팅방 목록 조회
    case fetchRooms

    /// 메시지 전송
    case sendMessage(roomId: String, SendMessageRequest)

    /// 메시지 목록 조회
    case fetchMessages(roomId: String, cursor: String?)

    /// 파일 업로드
    case uploadFiles(roomId: String)
}

// MARK: - Router

extension ChatRouter: Router {

    var path: String {
        switch self {
        case .createOrFetchRoom, .fetchRooms:
            return "/v1/chats"
        case .sendMessage(let roomId, _):
            return "/v1/chats/\(roomId)"
        case .fetchMessages(let roomId, _):
            return "/v1/chats/\(roomId)"
        case .uploadFiles(let roomId):
            return "/v1/chats/\(roomId)/files"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createOrFetchRoom, .sendMessage, .uploadFiles:
            return .post
        case .fetchRooms, .fetchMessages:
            return .get
        }
    }

    var isMultipartUpload: Bool {
        switch self {
        case .uploadFiles:
            return true
        default:
            return false
        }
    }

    var parameters: Parameters? {
        switch self {
        case .createOrFetchRoom(let request):
            return request.toDictionary()

        case .fetchRooms:
            return nil

        case .sendMessage(_, let request):
            return request.toDictionary()

        case .fetchMessages(_, let cursor):
            guard let cursor = cursor else { return nil }
            return ["next": cursor]

        case .uploadFiles:
            return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .fetchMessages:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}

// MARK: - Request Models

/// 채팅방 생성 요청
struct CreateChatRoomRequest: Encodable {
    let opponentId: String

    enum CodingKeys: String, CodingKey {
        case opponentId = "opponent_id"
    }
}

/// 메시지 전송 요청
struct SendMessageRequest: Encodable {
    let content: String
    let files: [String]

    init(content: String, fileURLs: [String] = []) {
        self.content = content
        self.files = fileURLs
    }
}
