//
//  ChatResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 채팅방 생성/조회 응답 DTO
struct ChatRoomCreateResponseDTO: Decodable {
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserSummaryDTO]
    let lastChat: ChatMessageDTO?

    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case updatedAt
        case participants
        case lastChat
    }
}

/// 채팅방 목록 응답 DTO
struct ChatRoomListResponseDTO: Decodable {
    let data: [ChatRoomDTO]
}

/// 채팅방 DTO
struct ChatRoomDTO: Decodable {
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserSummaryDTO]
    let lastChat: ChatMessageDTO?

    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case updatedAt
        case participants
        case lastChat
    }
}

/// 채팅 메시지 목록 응답 DTO
struct ChatMessageListResponseDTO: Decodable {
    let data: [ChatMessageDTO]
}

/// 채팅 메시지 DTO
struct ChatMessageDTO: Decodable {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserSummaryDTO
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content
        case createdAt
        case updatedAt
        case sender
        case files
    }
}
