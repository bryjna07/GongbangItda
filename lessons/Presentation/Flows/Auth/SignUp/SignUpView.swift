//
//  SignUpView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import SnapKit
import Then

final class SignUpView: BaseView {

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = GILabel(text: GIStrings.Auth.signUp, style: .title)

    // 이메일
    private let emailLabel = GILabel(text: GIStrings.Auth.SectionLabel.email, style: .sectionLabel)

    private let emailStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = GISpacing.sm
        $0.distribution = .fill
    }

    let emailTextField = GITextField(placeholder: GIStrings.Auth.Placeholder.email, style: .email)
    let emailCheckButton = GIButton(title: GIStrings.Auth.emailCheckDuplicate, style: .primary, size: .medium)
    private let emailValidationLabel = GILabel(style: .validation).then {
        $0.isHidden = true
    }

    // 비밀번호
    private let passwordLabel = GILabel(text: GIStrings.Auth.SectionLabel.password, style: .sectionLabel)
    let passwordTextField = GITextField(placeholder: GIStrings.Auth.Placeholder.passwordWithHint, style: .password)
    private let passwordValidationLabel = GILabel(style: .validation).then {
        $0.isHidden = true
    }

    // 닉네임
    private let nicknameLabel = GILabel(text: GIStrings.Auth.SectionLabel.nickname, style: .sectionLabel)
    let nicknameTextField = GITextField(placeholder: GIStrings.Auth.Placeholder.nickname)
    private let nicknameValidationLabel = GILabel(style: .validation).then {
        $0.isHidden = true
    }

    // 전화번호
    private let phoneNumLabel = GILabel(text: GIStrings.Auth.SectionLabel.phoneNumber, style: .sectionLabel)
    let phoneNumTextField = GITextField(placeholder: GIStrings.Auth.Placeholder.phoneNumber, style: .number)
    private let phoneNumValidationLabel = GILabel(style: .validation).then {
        $0.isHidden = true
    }

    // 소개
    private let introductionLabel = GILabel(text: GIStrings.Auth.SectionLabel.introduction, style: .sectionLabel)
    let introductionTextField = GITextField(placeholder: GIStrings.Auth.Placeholder.introduction)

    // 회원가입 버튼
    let signUpButton = GIButton(title: GIStrings.Auth.signUp, style: .primary, size: .large).then {
        $0.isEnabled = false
    }

    // MARK: - Configuration

    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            titleLabel,
            emailLabel, emailStackView, emailValidationLabel,
            passwordLabel, passwordTextField, passwordValidationLabel,
            nicknameLabel, nicknameTextField, nicknameValidationLabel,
            phoneNumLabel, phoneNumTextField, phoneNumValidationLabel,
            introductionLabel, introductionTextField,
            signUpButton
        ]
            .forEach { contentView.addSubview($0) }

        [
            emailTextField, emailCheckButton
        ]
            .forEach { emailStackView.addArrangedSubview($0) }
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(GISpacing.xxl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(GISpacing.xxxl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        emailStackView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
            $0.height.equalTo(GITextField.standardHeight)
        }

        emailCheckButton.snp.makeConstraints {
            $0.width.equalTo(GISize.emailCheckButtonWidth)
        }

        emailValidationLabel.snp.makeConstraints {
            $0.top.equalTo(emailStackView.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailValidationLabel.snp.bottom).offset(GISpacing.lg)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
            $0.height.equalTo(GITextField.standardHeight)
        }

        passwordValidationLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(passwordValidationLabel.snp.bottom).offset(GISpacing.lg)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
            $0.height.equalTo(GITextField.standardHeight)
        }

        nicknameValidationLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        phoneNumLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameValidationLabel.snp.bottom).offset(GISpacing.lg)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        phoneNumTextField.snp.makeConstraints {
            $0.top.equalTo(phoneNumLabel.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
            $0.height.equalTo(GITextField.standardHeight)
        }

        phoneNumValidationLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumTextField.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        introductionLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumValidationLabel.snp.bottom).offset(GISpacing.lg)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
        }

        introductionTextField.snp.makeConstraints {
            $0.top.equalTo(introductionLabel.snp.bottom).offset(GISpacing.xs)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
            $0.height.equalTo(GITextField.standardHeight)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(introductionTextField.snp.bottom).offset(GISpacing.xxxl)
            $0.horizontalEdges.equalToSuperview().inset(GISpacing.screenHorizontal)
            if let height = signUpButton.heightConstraint {
                $0.height.equalTo(height)
            }
            $0.bottom.equalToSuperview().offset(-GISpacing.xxl)
        }
    }

    override func configureView() {
        super.configureView()
    }

    // MARK: - Public Methods

    func showEmailValidation(message: String, isValid: Bool) {
        emailValidationLabel.showValidation(message: message, isValid: isValid)
    }

    func hideEmailValidation() {
        emailValidationLabel.hideValidation()
    }

    func showPasswordValidation(message: String) {
        passwordValidationLabel.showValidation(message: message, isValid: false)
    }

    func hidePasswordValidation() {
        passwordValidationLabel.hideValidation()
    }

    func showNicknameValidation(message: String) {
        nicknameValidationLabel.showValidation(message: message, isValid: false)
    }

    func hideNicknameValidation() {
        nicknameValidationLabel.hideValidation()
    }

    func showPhoneNumValidation(message: String) {
        phoneNumValidationLabel.showValidation(message: message, isValid: false)
    }

    func hidePhoneNumValidation() {
        phoneNumValidationLabel.hideValidation()
    }

    func updateSignUpButtonState(isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
    }
}
