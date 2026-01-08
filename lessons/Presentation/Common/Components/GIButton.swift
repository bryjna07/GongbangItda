//
//  GIButton.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit

/// 공방 디자인 시스템 버튼
final class GIButton: UIButton {

    // MARK: - Style
    enum Style {
        case primary        // 주요 액션 (blackSeafoam 배경)
        case secondary      // 보조 액션 (gray60 배경)
        case outline        // 외곽선만
        case text           // 텍스트만

        var backgroundColor: UIColor {
            switch self {
            case .primary: return .blackSeafoam
            case .secondary: return .gray60
            case .outline, .text: return .clear
            }
        }

        var foregroundColor: UIColor {
            switch self {
            case .primary: return .white
            case .secondary: return .white
            case .outline: return .lightSeafoam
            case .text: return .gray100
            }
        }

        func strokeColor(isDisabled: Bool) -> UIColor? {
            switch self {
            case .outline:
                return isDisabled ? .gray45 : .lightSeafoam
            default:
                return nil
            }
        }

        var strokeWidth: CGFloat {
            switch self {
            case .outline: return 0.5
            default: return 0
            }
        }
    }

    // MARK: - Size
    enum Size {
        case large      // 52pt
        case medium     // 44pt
        case small      // 32pt
        case compact    // 작은 인라인 버튼 (높이 자동)

        var height: CGFloat? {
            switch self {
            case .large: return 52
            case .medium: return 44
            case .small: return 32
            case .compact: return nil
            }
        }

        var font: UIFont {
            switch self {
            case .large: return GIFonts.body1
            case .medium: return GIFonts.body2
            case .small: return GIFonts.body3
            case .compact: return GIFonts.caption1
            }
        }

        var contentInsets: NSDirectionalEdgeInsets {
            switch self {
            case .large: return NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
            case .medium: return NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            case .small: return NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .compact: return NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            }
        }
    }

    // MARK: - Properties
    private let buttonStyle: Style
    private let size: Size

    // MARK: - Initialization
    init(title: String, style: Style = .primary, size: Size = .medium) {
        self.buttonStyle = style
        self.size = size
        super.init(frame: .zero)

        configure(title: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configure(title: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseForegroundColor = buttonStyle.foregroundColor
        config.baseBackgroundColor = buttonStyle.backgroundColor
        config.contentInsets = size.contentInsets
        config.cornerStyle = .fixed
        config.background.cornerRadius = size == .compact ? 10 : GIRadius.button

        // Outline 스타일 초기 stroke 설정
        config.background.strokeColor = buttonStyle.strokeColor(isDisabled: false)
        config.background.strokeWidth = buttonStyle.strokeWidth

        // 타이포그래피
        let buttonSize = size
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = buttonSize.font
            return outgoing
        }

        self.configuration = config
        self.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var config = button.configuration
            let isDisabled = !button.isEnabled

            if isDisabled {
                config?.baseBackgroundColor = .gray60
                config?.baseForegroundColor = .white
                config?.background.strokeColor = nil
                config?.background.strokeWidth = 0
                button.alpha = 0.5
            } else {
                config?.baseBackgroundColor = self.buttonStyle.backgroundColor
                config?.baseForegroundColor = self.buttonStyle.foregroundColor
                config?.background.strokeColor = self.buttonStyle.strokeColor(isDisabled: false)
                config?.background.strokeWidth = self.buttonStyle.strokeWidth
                button.alpha = 1.0
            }

            button.configuration = config
        }
    }

    // MARK: - Public Methods

    /// 버튼 크기 제약조건 생성 (SnapKit 사용 시 height만 설정)
    var heightConstraint: CGFloat? {
        size.height
    }
}
