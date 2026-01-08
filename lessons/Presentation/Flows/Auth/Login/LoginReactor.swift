//
//  LoginReactor.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift
import ReactorKit

/// 로그인 화면 상태 관리
final class LoginReactor: Reactor {

    // MARK: - Action
    enum Action {
        case didTapEmailLogin
        case didTapKakaoLogin
        case didTapAppleLogin
        case didTapSignUp
    }

    // MARK: - Mutation
    enum Mutation {
        case setLoginSuccess
        case navigateToEmailLogin
        case navigateToSignUp
        case navigateToForgotInfo
    }

    // MARK: - State
    struct State {
        @Pulse var shouldNavigateToEmailLogin: Bool = false
        @Pulse var shouldNavigateToSignUp: Bool = false
        @Pulse var shouldNavigateToForgotInfo: Bool = false
        @Pulse var loginSucceeded: Bool = false
    }

    // MARK: - Properties
    let initialState: State
    private let useCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Initialization
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State()
    }

    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapEmailLogin:
            return .just(.navigateToEmailLogin)

        case .didTapKakaoLogin:
            return performKakaoLogin()

        case .didTapAppleLogin:
            return performAppleLogin()

        case .didTapSignUp:
            return .just(.navigateToSignUp)

        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {

        case .setLoginSuccess:
            newState.loginSucceeded = true

        case .navigateToEmailLogin:
            newState.shouldNavigateToEmailLogin = true

        case .navigateToSignUp:
            newState.shouldNavigateToSignUp = true

        case .navigateToForgotInfo:
            newState.shouldNavigateToForgotInfo = true
        }

        return newState
    }

    // MARK: - Private Methods

    private func performKakaoLogin() -> Observable<Mutation> {
        // TODO: 카카오 SDK 연동 후 구현
        print("카카오 로그인 준비 중입니다")
        return .empty()
    }

    private func performAppleLogin() -> Observable<Mutation> {
        // TODO: Apple Sign In 연동 후 구현
        print("Apple 로그인 준비 중입니다")
        return .empty()
    }
}
