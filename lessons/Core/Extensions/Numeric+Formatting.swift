//
//  Numeric+Formatting.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import Foundation

// MARK: - Int Extension (가격, 숫자 표시)

extension Int {

    /// 원화 표시 (예: 50000 → "50,000원")
    var wonString: String {
        self.formatted(.number.locale(Locale(identifier: "ko_KR"))) + "원"
    }

    /// 천 단위 콤마 (예: 50000 → "50,000")
    var decimalString: String {
        self.formatted(.number.locale(Locale(identifier: "ko_KR")))
    }

    /// 축약 표시 (예: 15000 → "1.5만", 1500000 → "150만")
    /// - 리뷰 개수, 조회수 등에 사용
    var abbreviatedString: String {
        switch self {
        case ..<1000:
            return "\(self)"
        case ..<10000:
            return decimalString
        case ..<100_000_000:
            let tenThousands = Double(self) / 10_000  // 만 단위 (10,000)
            if tenThousands.truncatingRemainder(dividingBy: 1) == 0 {
                return "\(Int(tenThousands))만"
            } else {
                return String(format: "%.1f만", tenThousands)
            }
        default:
            let hundredMillions = Double(self) / 100_000_000  // 억 단위 (100,000,000)
            return String(format: "%.1f억", hundredMillions)
        }
    }
}

// MARK: - Double Extension (소수점, 퍼센트)

extension Double {

    /// 별점 표시 (예: 4.5 → "4.5", 4.0 → "4")
    var ratingString: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        }
        return String(format: "%.1f", self)
    }

    /// 퍼센트 표시 (예: 0.156 → "15.6%", 0.67 → "67%")
    var percentString: String {
        let percent = self * 100
        if percent.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f%%", percent)
        }
        return String(format: "%.1f%%", percent)
    }

    /// 소수점 표시 (예: 3.14159 → "3.14")
    /// - Parameter decimalPlaces: 소수점 자리수
    func formatted(decimalPlaces: Int = 2) -> String {
        String(format: "%.\(decimalPlaces)f", self)
    }
}
