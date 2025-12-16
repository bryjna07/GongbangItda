//
//  Date+Formatting.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import Foundation

// MARK: - Date Extension

extension Date {

    /// Date → String 변환 (async)
    /// - 대량 데이터 처리 시 사용
    func toString(format: DateFormat, locale: Locale = Locale(identifier: "ko_KR")) async -> String {
        let formatter = await DateFormatterManager.shared.formatter(for: format.rawValue, locale: locale)
        return formatter.string(from: self)
    }

    /// Date → String 변환 (동기)
    /// - UI 바인딩 시 사용 (메인 스레드)
    func toString(format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }

    /// 커스텀 포맷 (동기)
    func toString(customFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = customFormat
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }

    /// 상대 시간 표시 (채팅, SNS용)
    /// - "방금 전", "3분 전", "2시간 전", "5일 전"
    var relativeTime: String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: self, to: now)

        if let week = components.weekOfYear, week > 0 {
            return toString(format: .displayDate)
        } else if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }

    /// 채팅 목록 시간 표시
    /// - 오늘: "오후 3:30"
    /// - 어제: "어제"
    /// - 올해: "1월 15일"
    /// - 작년: "2024.01.15"
    var chatListTime: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return toString(format: .chatTime)
        } else if calendar.isDateInYesterday(self) {
            return "어제"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .year) {
            return toString(format: .displayMonthDay)
        } else {
            return toString(format: .displayDate)
        }
    }

    /// 채팅 날짜 구분선
    /// - 오늘: "오늘"
    /// - 어제: "어제"
    /// - 올해: "1월 15일 월요일"
    /// - 작년: "2024년 1월 15일"
    var chatDateSeparator: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return "오늘"
        } else if calendar.isDateInYesterday(self) {
            return "어제"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .year) {
            return toString(format: .chatDate)
        } else {
            return toString(customFormat: "yyyy년 M월 d일")
        }
    }
}

// MARK: - String Extension

extension String {

    /// String → Date 변환 (async)
    func toDate(format: DateFormat) async -> Date? {
        let formatter = await DateFormatterManager.shared.formatter(for: format.rawValue)
        return formatter.date(from: self)
    }

    /// String → Date 변환 (동기)
    func toDate(format: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
}
