//
//  EditProfileViewController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import RxSwift
import RxCocoa

/// 프로필 수정 모달
final class EditProfileViewController: BaseViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let editProfileView = EditProfileView()

    var onSave: ((String?, String?, String?) -> Void)?

    private let nickname: String?
    private let phoneNumber: String?
    private let introduction: String?

    // MARK: - Initialization
    init(nickname: String?, phoneNumber: String?, introduction: String?) {
        self.nickname = nickname
        self.phoneNumber = phoneNumber
        self.introduction = introduction
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTextFieldLimits()
        editProfileView.configure(nickname: nickname, phoneNumber: phoneNumber, introduction: introduction)
        validateNickname()
    }

    // MARK: - Setup

    private func setupBindings() {
        // 닉네임 입력 변경 시 검증
        editProfileView.nicknameTextField.rx.text
            .skip(1)
            .subscribe(with: self) { owner, _ in
                owner.validateNickname()
            }
            .disposed(by: disposeBag)

        // 저장 버튼 탭
        editProfileView.saveButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.handleSave()
            }
            .disposed(by: disposeBag)
    }

    /// TextField 글자 수 제한 설정
    private func setupTextFieldLimits() {
        // 닉네임 최대 글자 수
        editProfileView.nicknameTextField.rx.text.orEmpty
            .scan("") { prev, new in
                new.count > InputValidator.nicknameMaxLength ? prev : new
            }
            .bind(to: editProfileView.nicknameTextField.rx.text)
            .disposed(by: disposeBag)

        // 전화번호 최대 글자 수
        editProfileView.phoneNumberTextField.rx.text.orEmpty
            .scan("") { prev, new in
                new.count > InputValidator.phoneNumberMaxLength ? prev : new
            }
            .bind(to: editProfileView.phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: - Validation

    private func validateNickname() {
        let nickname = editProfileView.nicknameTextField.text
        let result = InputValidator.validateNickname(nickname)

        editProfileView.updateNicknameValidation(errorMessage: result.errorMessage)
        editProfileView.updateSaveButtonEnabled(result.isValid)
    }

    private func handleSave() {
        let nickname = editProfileView.nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNumber = editProfileView.phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let introduction = editProfileView.introductionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        // 닉네임 필수 검증
        guard InputValidator.validateNickname(nickname).isValid else { return }

        onSave?(
            nickname?.isEmpty == false ? nickname : nil,
            phoneNumber?.isEmpty == false ? phoneNumber : nil,
            introduction?.isEmpty == false ? introduction : nil
        )

        dismiss(animated: true)
    }
}
