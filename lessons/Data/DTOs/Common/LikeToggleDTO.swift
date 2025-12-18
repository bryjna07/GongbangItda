//
//  LikeToggleDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import Foundation

/// 좋아요 토글 DTO (Request/Response 동일)
struct LikeToggleDTO: Codable {
    let likeStatus: Bool

    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }

    init(isLiked: Bool) {
        self.likeStatus = isLiked
    }
}
