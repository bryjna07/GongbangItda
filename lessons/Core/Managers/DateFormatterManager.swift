//
//  DateFormatterManager.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import Foundation

/// 날짜 포맷 타입 정의
enum DateFormat: String {
    // MARK: - Server Format (API 통신용)
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case iso8601Simple = "yyyy-MM-dd'T'HH:mm:ss"
    case apiDate = "yyyy-MM-dd"
    case apiDateTime = "yyyy-MM-dd HH:mm:ss"

    // MARK: - Display Format (UI 표시용)
    case displayDate = "yyyy.MM.dd"
    case displayDateTime = "yyyy.MM.dd HH:mm"
    case displayMonthDay = "M월 d일"
    case displayTime = "HH:mm"
    case displayWeekday = "EEEE"
    case displayFull = "yyyy년 M월 d일 (E)"

    // MARK: - Chat Format (채팅용)
    case chatTime = "a h:mm"          // 오후 3:30
    case chatDate = "M월 d일 EEEE"    // 1월 15일 월요일
}

// MARK: - DateFormatterManager (Actor)

/// DateFormatter 캐싱 관리
actor DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}

    private var formatters: [String: DateFormatter] = [:]

    /// 포맷별 DateFormatter 반환 (캐싱)
    func formatter(for format: String, locale: Locale = Locale(identifier: "ko_KR")) -> DateFormatter {
        let key = "\(format)_\(locale.identifier)"

        if let cached = formatters[key] {
            return cached
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatters[key] = formatter

        return formatter
    }

    /// 캐시 초기화 (locale 변경 시 사용)
    func clearCache() {
        formatters.removeAll()
        Log.info("DateFormatterManager 캐시 초기화 완료")
    }
}
