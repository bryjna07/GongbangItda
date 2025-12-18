//
//  ActivityScheduleDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

/// 공방 스케줄 DTO (서버 응답용)
struct ScheduleDTO: Decodable {
    let duration: String
    let description: String
}
