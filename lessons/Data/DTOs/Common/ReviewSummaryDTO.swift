//
//  ReviewSummaryDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 리뷰 요약 정보 DTO (주문 목록 등에서 사용)
struct ReviewSummaryDTO: Decodable {
    let id: String
    let rating: Int
}
