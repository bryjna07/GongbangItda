//
//  ProfileView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import SnapKit
import Then

final class ProfileView: BaseView {

    // MARK: - UI Components

    /// 프로필 이미지 영역
    private let profileImageContainer = UIView()
    let profileImageView = UIImageView()
    let cameraButton = UIButton()

    /// 프로필 카드 영역
    private let profileCardView = GICardView()

    /// 수정 버튼
    let editButton = GIButton(title: GIStrings.Common.edit, style: .outline, size: .compact)

    /// 닉네임
    private let nicknameLabel = UILabel()

    /// 소개글
    private let introductionLabel = UILabel()

    /// 관심 카테고리 태그 (최대 3개)
    private let categoryStackView = UIStackView()
    private let firstCategoryTag = GITagLabel(color: .deepSeafoam)
    private let secondCategoryTag = GITagLabel(color: .deepSeafoam)
    private let thirdCategoryTag = GITagLabel(color: .deepSeafoam)

    /// 통계 영역
    private let statsContainerView = UIView()
    private let statsDivider = UIView()
    private let amountStatsView = GIStatsItemView(
        iconName: GIIcons.wonSign,
        value: GIStrings.Profile.Stats.defaultAmount,
        title: GIStrings.Profile.Stats.totalAmountTitle
    )
    private let pointStatsView = GIStatsItemView(
        iconName: GIIcons.plusCircle,
        value: GIStrings.Profile.Stats.defaultPoints,
        title: GIStrings.Profile.Stats.totalPointsTitle
    )

    //TODO: - 하단 추후 내 공방 목록 구성 (결제한 공방들)

    // MARK: - Configuration

    override func configureHierarchy() {
        [profileImageContainer, profileCardView].forEach { addSubview($0) }

        [profileImageView, cameraButton].forEach { profileImageContainer.addSubview($0) }

        [
            editButton,
            nicknameLabel,
            introductionLabel,
            categoryStackView,
            statsContainerView
        ].forEach { profileCardView.addSubview($0) }

        [firstCategoryTag, secondCategoryTag, thirdCategoryTag].forEach {
            categoryStackView.addArrangedSubview($0)
        }

        [amountStatsView, statsDivider, pointStatsView].forEach {
            statsContainerView.addSubview($0)
        }
    }

    override func configureLayout() {

        profileImageContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(GISpacing.lg)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(GISize.profileImageContainer)
        }

        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        // profileImageView 오른쪽 아래에 겹치게
        cameraButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(GISize.cameraButton)
        }

        profileCardView.snp.makeConstraints {
            $0.top.equalTo(profileImageContainer.snp.bottom).offset(GISpacing.lg)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        editButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(2)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(GISpacing.xl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
        }

        introductionLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(GISpacing.sm)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
        }

        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(introductionLabel.snp.bottom).offset(GISpacing.lg)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
        }

        statsContainerView.snp.makeConstraints {
            $0.top.equalTo(categoryStackView.snp.bottom).offset(GISpacing.xl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
            $0.bottom.equalToSuperview().inset(GISpacing.xl)
        }

        amountStatsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(statsDivider.snp.leading)
        }

        statsDivider.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(GISize.dividerWidth)
        }

        pointStatsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(statsDivider.snp.trailing)
            $0.trailing.equalToSuperview()
        }
    }

    override func configureView() {
        super.configureView()
        backgroundColor = .gray15

        profileImageView.do {
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = GISize.profileImageRadius
            $0.layer.borderColor = UIColor.deepSeafoam.cgColor
            $0.layer.borderWidth = GIBorder.thin
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = .icon(GIIcons.personFill)
            $0.tintColor = .gray45
        }

        cameraButton.do {
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = GISize.cameraButtonRadius
            $0.layer.borderColor = UIColor.lightSeafoam.cgColor
            $0.layer.borderWidth = GIBorder.thin
            $0.setImage(.icon(GIIcons.cameraFill), for: .normal)
            $0.tintColor = .deepSeafoam
        }

        nicknameLabel.do {
            $0.text = GIStrings.Profile.defaultNickname
            $0.font = GIFonts.pretendardTitle1
            $0.textColor = .gray90
        }

        introductionLabel.do {
            $0.text = GIStrings.Profile.defaultIntroduction
            $0.font = GIFonts.caption1
            $0.textColor = .gray60
            $0.textAlignment = .center
            $0.numberOfLines = 4
        }

        categoryStackView.do {
            $0.axis = .horizontal
            $0.spacing = GISpacing.sm
            $0.alignment = .center
        }

        // 카테고리 태그 초기값 설정
        firstCategoryTag.update(text: GIStrings.Profile.Category.first)
        secondCategoryTag.update(text: GIStrings.Profile.Category.second)
        thirdCategoryTag.update(text: GIStrings.Profile.Category.third)

        statsContainerView.do {
            $0.backgroundColor = .clear
        }

        statsDivider.do {
            $0.backgroundColor = .systemGray4
        }
    }

    // MARK: - Public Methods

    func configure(
        nickname: String,
        introduction: String?,
        profileImageURL: String?,
        totalAmount: String,
        totalPoints: String,
        categories: [String]
    ) {
        nicknameLabel.text = nickname
        introductionLabel.text = introduction ?? ""
        amountStatsView.updateValue(totalAmount)
        pointStatsView.updateValue(totalPoints)

        // 프로필 이미지 로드 (FileRouter 활용)
        if let imagePath = profileImageURL {
            let fullURL = FileRouter.fileURL(from: imagePath)
            profileImageView.setProfileImage(
                with: fullURL,
                placeholder: .icon(GIIcons.personFill)
            )
        } else {
            profileImageView.image = .icon(GIIcons.personFill)
        }

        // TODO: 카테고리 태그 동적 업데이트 (주문내역에서 카테고리 많은 순), 추후 서버연동
    }
}
