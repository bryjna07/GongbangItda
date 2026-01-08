//
//  GICardView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/28/25.
//

import UIKit

/// 공방 디자인 시스템 카드 뷰
/// - Note: 그림자와 둥근 모서리가 적용된 컨테이너 뷰
final class GICardView: UIView {

    // MARK: - Style
    enum Style {
        case elevated       // 그림자 있음
        case flat           // 그림자 없음

        var shadowOpacity: Float {
            switch self {
            case .elevated: return 0.05
            case .flat: return 0
            }
        }
    }

    // MARK: - Initialization
    init(style: Style = .elevated) {
        super.init(frame: .zero)
        configure(style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configure(style: Style) {
        backgroundColor = .gray0
        layer.cornerRadius = GIRadius.lg  // 16pt

        // 그림자 설정
        layer.shadowColor = UIColor.lightSeafoam.cgColor
        layer.shadowOpacity = style.shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
    }
}
