//
//  GIStatsItemView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/28/25.
//

import UIKit
import SnapKit
import Then

/// 공방 디자인 시스템 통계 아이템 뷰
/// - Note: 아이콘 + 값 + 제목 형태의 통계 표시에 사용
final class GIStatsItemView: UIView {

    // MARK: - UI Components
    private let stackView = UIStackView()
    private let iconView = UIImageView()
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: - Initialization
    init(iconName: String, value: String, title: String) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView(iconName: iconName, value: value, title: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configureHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(titleLabel)
    }

    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        iconView.snp.makeConstraints {
            $0.size.equalTo(GISize.statsIcon)
        }
    }

    private func configureView(iconName: String, value: String, title: String) {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = GISpacing.xs
            $0.alignment = .center
        }

        iconView.do {
            $0.image = .icon(iconName)
            $0.tintColor = .blackSeafoam
            $0.contentMode = .scaleAspectFit
        }

        valueLabel.do {
            $0.text = value
            $0.font = GIFonts.body3Bold
            $0.textColor = .gray75
        }

        titleLabel.do {
            $0.text = title
            $0.font = GIFonts.caption1Medium
            $0.textColor = .gray45
        }
    }

    // MARK: - Public Methods

    /// 값 업데이트
    func updateValue(_ value: String) {
        valueLabel.text = value
    }

    /// 아이콘 및 제목 업데이트
    func update(iconName: String? = nil, value: String? = nil, title: String? = nil) {
        if let iconName = iconName {
            iconView.image = .icon(iconName)
        }
        if let value = value {
            valueLabel.text = value
        }
        if let title = title {
            titleLabel.text = title
        }
    }
}
