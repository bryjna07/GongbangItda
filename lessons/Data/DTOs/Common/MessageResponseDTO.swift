//
//  MessageResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 서버 메시지 응답 DTO (공통)
struct MessageResponseDTO: Decodable {
    let message: String
}
