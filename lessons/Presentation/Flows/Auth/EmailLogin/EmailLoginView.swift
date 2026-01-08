//
//  EmailLoginView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import SnapKit
import Then

/// 이메일 로그인 화면 UI
final class EmailLoginView: BaseView {

    // MARK: - UI Components

    private let titleLabel = GILabel(
        text: GIStrings.Auth.emailLogin,
        style: .title
    )

    private let emailLabel = GILabel(
        text: GIStrings.Auth.SectionLabel.email,
        style: .sectionLabel
    )

    let emailTextField = GITextField(
        placeholder: GIStrings.Auth.Placeholder.emailInput,
        style: .email
    )

    private let passwordLabel = GILabel(
        text: GIStrings.Auth.SectionLabel.password,
        style: .sectionLabel
    )

    let passwordTextField = GITextField(
        placeholder: GIStrings.Auth.Placeholder.passwordInput,
        style: .password
    )

    let loginButton = GIButton(
        title: GIStrings.Auth.login,
        style: .primary,
        size: .large
    )

    private let validationLabel = GILabel(
        text: "",
        style: .validation
    )

    // MARK: - Configuration

    override func configureHierarchy() {
        [titleLabel, emailLabel, emailTextField, passwordLabel, passwordTextField, loginButton, validationLabel].forEach {
            addSubview($0)
        }
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(GISpacing.section + GISpacing.xs)
            $0.leading.trailing.equalToSuperview().inset(GISpacing.xxl)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(GISpacing.section + GISpacing.xs)
            $0.leading.trailing.equalToSuperview().inset(GISpacing.xxl)
        }

        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(GISpacing.sm)
            $0.leading.trailing.equalToSuperview().inset(GISpacing.xxl)
            $0.height.equalTo(GITextField.standardHeight)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(GISpacing.xxl)
            $0.leading.trailing.equalToSuperview().inset(GISpacing.xxl)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(GISpacing.sm)
            $0.leading.trailing.equalToSuperview().inset(GISpacing.xxl)
            $0.height.equalTo(GITextField.standardHeight)
        }

        validationLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(GISpacing.md)
            $0.leading.trailing.equalToSuperview().inset(GISpacing.xxl)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(validationLabel.snp.bottom).offset(GISpacing.xxxl)
            $0.leading.trailing.equalToSuperview().inset(GISpacing.xxl)
            if let height = loginButton.heightConstraint {
                $0.height.equalTo(height)
            }
        }
    }

    override func configureView() {
        super.configureView()
        loginButton.isEnabled = false
    }

    // MARK: - Public Methods

    func updateLoginButton(enabled: Bool) {
        loginButton.isEnabled = enabled
    }

    func showError(_ message: String) {
        validationLabel.showValidation(message: message, isValid: false)
    }

    func hideError() {
        validationLabel.hideValidation()
    }
}
