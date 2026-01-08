//
//  GIIcons.swift
//  lessons
//
//  Created by Watson22_YJ on 12/29/25.
//

import UIKit

/// 디자인 시스템 아이콘 상수 (SF Symbols)
enum GIIcons {

    // MARK: - Navigation

    /// 뒤로가기 화살표
    static let chevronLeft = "chevron.left"

    /// 설정 기어
    static let settings = "gearshape"
    static let settingsFill = "gearshape.fill"

    // MARK: - TabBar

    static let home = "house"
    static let homeFill = "house.fill"

    static let search = "square.grid.2x2"
    static let searchFill = "square.grid.2x2.fill"

    static let bookmark = "bookmark"
    static let bookmarkFill = "bookmark.fill"

    // MARK: - Profile

    static let person = "person"
    static let personFill = "person.fill"

    static let camera = "camera"
    static let cameraFill = "camera.fill"

    // MARK: - Auth / Social

    static let kakaoMessage = "message.fill"
    static let appleLogo = "apple.logo"
    static let pencil = "pencil"

    // MARK: - Stats

    static let wonSign = "wonsign.circle.fill"
    static let plusCircle = "plus.circle.fill"

    // MARK: - Misc

    static let book = "book"
    static let bookFill = "book.fill"
}

// MARK: - UIImage Extension

extension UIImage {
    /// GIIcons 상수를 사용하여 SF Symbol 이미지 생성
    static func icon(_ name: String) -> UIImage? {
        return UIImage(systemName: name)
    }
}
