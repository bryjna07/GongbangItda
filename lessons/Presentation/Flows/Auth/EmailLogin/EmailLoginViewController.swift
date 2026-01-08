//
//  EmailLoginViewController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

/// 이메일 로그인 화면
final class EmailLoginViewController: BaseViewController, View {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?

    // MARK: - UI Components
    private let emailLoginView = EmailLoginView()

    // MARK: - Initialization
    init(reactor: EmailLoginReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = emailLoginView
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
        navigationItem.title = GIStrings.Auth.emailLogin
    }

    // MARK: - Bind
    func bind(reactor: EmailLoginReactor) {
        // Action - 이메일 입력
        emailLoginView.emailTextField.rx.text.orEmpty
            .skip(1)
            .map { Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // Action - 비밀번호 입력
        emailLoginView.passwordTextField.rx.text.orEmpty
            .skip(1)
            .map { Reactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // Action - 로그인 버튼
        emailLoginView.loginButton.rx.tap
            .map { Reactor.Action.didTapLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State - 로그인 버튼 활성화
        reactor.state.map { $0.canLogin }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, canLogin in
                owner.emailLoginView.updateLoginButton(enabled: canLogin)
            }
            .disposed(by: disposeBag)

        // State - 로딩 상태
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isLoading in
                if isLoading {
                    owner.showLoading()
                } else {
                    owner.hideLoading()
                }
            }
            .disposed(by: disposeBag)

        // State - 에러 메시지
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, message in
                if let message = message {
                    owner.emailLoginView.showError(message)
                } else {
                    owner.emailLoginView.hideError()
                }
            }
            .disposed(by: disposeBag)

        // State - 로그인 성공 (asyncInstance로 reentrancy 방지)
        reactor.pulse(\.$loginSucceeded)
            .filter { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self) { owner, _ in
                owner.coordinator?.loginDidComplete()
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods

    private func showLoading() {
        // TODO: 로딩 인디케이터 표시
    }

    private func hideLoading() {
        // TODO: 로딩 인디케이터 숨김
    }
}
