//
//  EditProfileView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import SnapKit
import Then

/// 프로필 수정 모달 View
final class EditProfileView: BaseView {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    let nicknameTextField = GITextField(placeholder: GIStrings.Auth.Placeholder.nickname)
    private let nicknameErrorLabel = UILabel()
    let phoneNumberTextField = GITextField(placeholder: GIStrings.Auth.Placeholder.phoneNumberOptional)
    let introductionTextView = UITextView()
    private let introductionPlaceholder = UILabel()
    let saveButton = GIButton(title: GIStrings.Common.save, style: .primary)

    // MARK: - Configuration

    override func configureHierarchy() {
        [
            titleLabel,
            nicknameTextField,
            nicknameErrorLabel,
            phoneNumberTextField,
            introductionTextView,
            saveButton
        ].forEach { addSubview($0) }
        introductionTextView.addSubview(introductionPlaceholder)
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(GISpacing.xxl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
        }

        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(GISpacing.xxl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
            $0.height.equalTo(GISize.textFieldHeight)
        }

        nicknameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
        }

        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameErrorLabel.snp.bottom).offset(GISpacing.md)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
            $0.height.equalTo(GISize.textFieldHeight)
        }

        introductionTextView.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(GISpacing.lg)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
            $0.height.equalTo(GISize.textViewHeight)
        }

        introductionPlaceholder.snp.makeConstraints {
            $0.top.equalToSuperview().inset(GISpacing.md)
            $0.leading.equalToSuperview().inset(GISpacing.sm)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(introductionTextView.snp.bottom).offset(GISpacing.xxl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.xl)
            if let height = saveButton.heightConstraint {
                $0.height.equalTo(height)
            }
            $0.bottom.equalToSuperview().inset(GISpacing.section + GISpacing.xs)
        }
    }

    override func configureView() {
        super.configureView()
        backgroundColor = .gray0

        titleLabel.do {
            $0.text = GIStrings.Profile.editTitle
            $0.font = GIFonts.body1
            $0.textColor = .gray90
        }

        nicknameErrorLabel.do {
            $0.font = GIFonts.body2
            $0.textColor = .systemRed
            $0.isHidden = true
        }

        phoneNumberTextField.do {
            $0.keyboardType = .numberPad
        }

        introductionTextView.do {
            $0.font = GIFonts.body2
            $0.textColor = .gray90
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = GIRadius.md
            $0.layer.borderWidth = GIBorder.regular
            $0.layer.borderColor = UIColor.gray15.cgColor
            $0.textContainerInset = UIEdgeInsets(
                top: GISpacing.md,
                left: GISpacing.sm,
                bottom: GISpacing.md,
                right: GISpacing.sm
            )
            $0.delegate = self
        }

        introductionPlaceholder.do {
            $0.text = GIStrings.Auth.Placeholder.introductionOptional
            $0.font = GIFonts.body2
            $0.textColor = .gray45
        }
    }

    // MARK: - Public Methods

    func configure(nickname: String?, phoneNumber: String?, introduction: String?) {
        nicknameTextField.text = nickname
        phoneNumberTextField.text = phoneNumber
        introductionTextView.text = introduction

        introductionPlaceholder.isHidden = !(introduction?.isEmpty ?? true)
    }

    /// 닉네임 검증 상태 업데이트
    func updateNicknameValidation(errorMessage: String?) {
        nicknameErrorLabel.text = errorMessage
        nicknameErrorLabel.isHidden = errorMessage == nil
    }

    /// 저장 버튼 활성화 상태 업데이트
    func updateSaveButtonEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1.0 : 0.5
    }
}

// MARK: - UITextViewDelegate

extension EditProfileView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        introductionPlaceholder.isHidden = !textView.text.isEmpty

        // 최대 글자 수 제한
        if textView.text.count > InputValidator.introductionMaxLength {
            textView.text = String(textView.text.prefix(InputValidator.introductionMaxLength))
        }
    }
}
