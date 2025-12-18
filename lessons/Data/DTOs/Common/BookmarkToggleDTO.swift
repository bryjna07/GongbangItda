//
//  BookmarkToggleDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import Foundation

/// 북마크 토글 DTO (Request/Response 동일)
struct BookmarkToggleDTO: Codable {
    let keepStatus: Bool

    enum CodingKeys: String, CodingKey {
        case keepStatus = "keep_status"
    }

    /// 초기화
    /// - Parameter isBookmarked: 북마크 상태 (true: 북마크, false: 북마크 해제)
    init(isBookmarked: Bool) {
        self.keepStatus = isBookmarked
    }
}
