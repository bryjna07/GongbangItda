//
//  GILabel.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit

/// 공방 디자인 시스템 레이블
final class GILabel: UILabel {

    // MARK: - Style
    enum Style {
        case title          // 화면 제목
        case sectionLabel   // 섹션 제목 (폼 레이블)
        case body           // 본문
        case caption        // 캡션
        case validation     // 검증 메시지

        var font: UIFont {
            switch self {
            case .title: return GIFonts.title1
            case .sectionLabel: return GIFonts.body3
            case .body: return GIFonts.body2
            case .caption: return GIFonts.caption1
            case .validation: return GIFonts.caption2
            }
        }

        var textColor: UIColor {
            switch self {
            case .title: return .gray100
            case .sectionLabel: return .gray75
            case .body: return .gray100
            case .caption: return .gray75
            case .validation: return .systemRed
            }
        }
    }

    // MARK: - Initialization
    init(text: String? = nil, style: Style = .body) {
        super.init(frame: .zero)

        configure(text: text, style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configure(text: String?, style: Style) {
        self.text = text
        self.font = style.font
        self.textColor = style.textColor
        self.numberOfLines = 0
    }

    // MARK: - Public Methods

    /// 검증 메시지 표시 (성공/실패에 따라 색상 변경)
    func showValidation(message: String, isValid: Bool) {
        self.text = message
        self.textColor = isValid ? .systemGreen : .systemRed
        self.isHidden = false
    }

    /// 검증 메시지 숨김
    func hideValidation() {
        self.isHidden = true
    }
}
