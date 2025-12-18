//
//  PostSearchResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 게시글 검색 응답 DTO
struct PostSearchResponseDTO: Decodable {
    let data: [PostSummaryDTO]
}
