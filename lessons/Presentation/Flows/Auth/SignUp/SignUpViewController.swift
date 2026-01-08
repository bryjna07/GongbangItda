//
//  SignUpViewController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

/// 회원가입 화면
final class SignUpViewController: BaseViewController, View {

    typealias Reactor = SignUpReactor

    // MARK: - Properties
    var disposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?

    // MARK: - UI Components
    private let signUpView = SignUpView()

    // MARK: - Initialization
    init(reactor: SignUpReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Setup
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = GIStrings.Auth.signUp
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .icon(GIIcons.chevronLeft),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Bind
    func bind(reactor: SignUpReactor) {
        // Action - Text Input
        signUpView.emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        signUpView.passwordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        signUpView.nicknameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        signUpView.phoneNumTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updatePhoneNum($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        signUpView.introductionTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateIntroduction($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // Action - Button Tap
        signUpView.emailCheckButton.rx.tap
            .map { Reactor.Action.didTapEmailCheck }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        signUpView.signUpButton.rx.tap
            .map { Reactor.Action.didTapSignUp }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State - Email Validation
        reactor.state.map { $0.isEmailValid }
            .distinctUntilChanged()
            .skip(1)
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isValid in
                if !isValid {
                    owner.signUpView.showEmailValidation(message: GIStrings.Auth.Validation.emailInvalid, isValid: false)
                } else {
                    owner.signUpView.hideEmailValidation()
                }
            }
            .disposed(by: disposeBag)

        // State - Email Check Success
        reactor.state.map { $0.isEmailChecked }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, _ in
                owner.signUpView.showEmailValidation(message: GIStrings.Auth.Validation.emailAvailable, isValid: true)
            }
            .disposed(by: disposeBag)

        // State - Password Validation
        Observable.combineLatest(
            reactor.state.map(\.isPasswordValid).distinctUntilChanged(),
            reactor.state.map(\.password).distinctUntilChanged()
        )
        .skip(1)
        .asDriver(onErrorJustReturn: (false, ""))
        .drive(with: self) { owner, tuple in
            let (isValid, password) = tuple
            if !password.isEmpty && !isValid {
                owner.signUpView.showPasswordValidation(message: GIStrings.Auth.Validation.passwordTooShort)
            } else {
                owner.signUpView.hidePasswordValidation()
            }
        }
        .disposed(by: disposeBag)

        // State - Nickname Validation
        Observable.combineLatest(
            reactor.state.map(\.isNicknameValid).distinctUntilChanged(),
            reactor.state.map(\.nickname).distinctUntilChanged()
        )
        .skip(1)
        .asDriver(onErrorJustReturn: (false, ""))
        .drive(with: self) { owner, tuple in
            let (isValid, nickname) = tuple
            if !nickname.isEmpty && !isValid {
                owner.signUpView.showNicknameValidation(message: GIStrings.Auth.Validation.nicknameSpecialChar)
            } else {
                owner.signUpView.hideNicknameValidation()
            }
        }
        .disposed(by: disposeBag)

        // State - PhoneNum Validation
        Observable.combineLatest(
            reactor.state.map(\.isPhoneNumValid).distinctUntilChanged(),
            reactor.state.map(\.phoneNum).distinctUntilChanged()
        )
        .skip(1)
        .asDriver(onErrorJustReturn: (false, ""))
        .drive(with: self) { owner, tuple in
            let (isValid, phoneNum) = tuple
            if !phoneNum.isEmpty && !isValid {
                owner.signUpView.showPhoneNumValidation(message: GIStrings.Auth.Validation.phoneNumberInvalid)
            } else {
                owner.signUpView.hidePhoneNumValidation()
            }
        }
        .disposed(by: disposeBag)

        // State - Sign Up Button
        reactor.state.map { $0.canSignUp }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, canSignUp in
                owner.signUpView.updateSignUpButtonState(isEnabled: canSignUp)
            }
            .disposed(by: disposeBag)

        // State - Loading
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isLoading in
                if isLoading {
                    owner.showLoadingIndicator()
                } else {
                    owner.hideLoadingIndicator()
                }
            }
            .disposed(by: disposeBag)

        // State - Error
        reactor.state.compactMap { $0.errorMessage }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, message in
                owner.showErrorAlert(message: message)
            }
            .disposed(by: disposeBag)

        // State - Sign Up Success (asyncInstance로 reentrancy 방지)
        reactor.pulse(\.$signUpSucceeded)
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self) { owner, _ in
                owner.coordinator?.signUpDidComplete()
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func showLoadingIndicator() {
        // TODO: 로딩 인디케이터 표시
    }

    private func hideLoadingIndicator() {
        // TODO: 로딩 인디케이터 숨김
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: GIStrings.Common.alert,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: GIStrings.Common.confirm, style: .default))
        present(alert, animated: true)
    }
}
