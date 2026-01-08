//
//  GITextField.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit

/// 공방 디자인 시스템 텍스트필드
final class GITextField: UITextField {

    // MARK: - Style
    enum Style {
        case `default`      // 기본 스타일
        case password       // 비밀번호 (secure)
        case email          // 이메일 (이메일 키보드)
        case number         // 숫자 (숫자 키보드)

        var keyboardType: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            case .number: return .numberPad
            default: return .default
            }
        }

        var isSecure: Bool {
            switch self {
            case .password: return true
            default: return false
            }
        }

        var autocapitalizationType: UITextAutocapitalizationType {
            switch self {
            case .email: return .none
            default: return .sentences
            }
        }
    }

    // MARK: - Properties
    private let style: Style

    // MARK: - Initialization
    init(placeholder: String, style: Style = .default) {
        self.style = style
        super.init(frame: .zero)

        configure(placeholder: placeholder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configure(placeholder: String) {
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.font = GIFonts.body2
        self.textColor = .gray100
        self.backgroundColor = .systemBackground
        self.keyboardType = style.keyboardType
        self.isSecureTextEntry = style.isSecure
        self.autocapitalizationType = style.autocapitalizationType
        self.autocorrectionType = .no
        self.clearButtonMode = .whileEditing
    }

    // MARK: - Public Methods

    /// 텍스트필드 높이 제약조건
    static var standardHeight: CGFloat {
        44
    }
}
