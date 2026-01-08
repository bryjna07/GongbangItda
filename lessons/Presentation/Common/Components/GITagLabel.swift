//
//  GITagLabel.swift
//  lessons
//
//  Created by Watson22_YJ on 12/28/25.
//

import UIKit

/// 공방 디자인 시스템 태그 레이블
/// - Note: 카테고리, 상태 표시 등에 사용
final class GITagLabel: UILabel {

    // MARK: - Style
    enum Style {
        case filled         // 배경색 채움
        case outline        // 외곽선만

        func backgroundColor(color: UIColor) -> UIColor {
            switch self {
            case .filled: return color
            case .outline: return .clear
            }
        }

        func textColor(color: UIColor) -> UIColor {
            switch self {
            case .filled: return .gray0
            case .outline: return color
            }
        }

        func borderColor(color: UIColor) -> CGColor? {
            switch self {
            case .filled: return nil
            case .outline: return color.cgColor
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .filled: return 0
            case .outline: return 1
            }
        }
    }

    // MARK: - Size
    enum Size {
        case medium     // 기본 크기
        case small      // 작은 크기

        var font: UIFont {
            switch self {
            case .medium: return GIFonts.caption1SemiBold
            case .small: return GIFonts.caption2
            }
        }

        var padding: UIEdgeInsets {
            switch self {
            case .medium: return UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            case .small: return UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .medium: return 12
            case .small: return 8
            }
        }
    }

    // MARK: - Properties
    private var padding: UIEdgeInsets = .zero

    // MARK: - Initialization
    init(
        text: String? = nil,
        color: UIColor = .deepSeafoam,
        style: Style = .filled,
        size: Size = .medium
    ) {
        super.init(frame: .zero)
        configure(text: text, color: color, style: style, size: size)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Override
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + padding.left + padding.right,
            height: size.height + padding.top + padding.bottom
        )
    }

    // MARK: - Configuration
    private func configure(text: String?, color: UIColor, style: Style, size: Size) {
        self.text = text
        self.font = size.font
        self.textColor = style.textColor(color: color)
        self.backgroundColor = style.backgroundColor(color: color)
        self.padding = size.padding

        layer.cornerRadius = size.cornerRadius
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor(color: color)
        clipsToBounds = true
    }

    // MARK: - Public Methods

    /// 태그 텍스트 및 색상 업데이트
    func update(text: String?, color: UIColor? = nil, style: Style? = nil) {
        self.text = text

        if let color = color, let style = style {
            self.textColor = style.textColor(color: color)
            self.backgroundColor = style.backgroundColor(color: color)
            layer.borderWidth = style.borderWidth
            layer.borderColor = style.borderColor(color: color)
        }
    }
}
