//
//  LoginViewController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

/// 로그인 화면
final class LoginViewController: BaseViewController, View {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?

    // MARK: - UI Components
    private let loginView = LoginView()

    // MARK: - Initialization
    init(reactor: LoginReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Bind
    func bind(reactor: LoginReactor) {
        // Action
        loginView.emailLoginButton.rx.tap
            .map { Reactor.Action.didTapEmailLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        loginView.kakaoLoginButton.rx.tap
            .map { Reactor.Action.didTapKakaoLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        loginView.appleLoginButton.rx.tap
            .map { Reactor.Action.didTapAppleLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        loginView.signUpButton.rx.tap
            .map { Reactor.Action.didTapSignUp }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State - Navigation to Email Login
        reactor.pulse(\.$shouldNavigateToEmailLogin)
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, _ in
                owner.coordinator?.showEmailLogin()
            }
            .disposed(by: disposeBag)

        // State - Navigation to Sign Up
        reactor.pulse(\.$shouldNavigateToSignUp)
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, _ in
                owner.coordinator?.showSignUp()
            }
            .disposed(by: disposeBag)

        // State - Login Success (asyncInstance로 reentrancy 방지)
        reactor.pulse(\.$loginSucceeded)
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self) { owner, _ in
                owner.coordinator?.loginDidComplete()
            }
            .disposed(by: disposeBag)
    }
}
