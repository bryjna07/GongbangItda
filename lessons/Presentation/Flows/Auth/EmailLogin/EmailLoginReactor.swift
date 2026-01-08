//
//  EmailLoginReactor.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift
import ReactorKit
import FirebaseMessaging

/// 이메일 로그인 화면 상태 관리
final class EmailLoginReactor: Reactor {

    // MARK: - Action
    enum Action {
        case updateEmail(String)
        case updatePassword(String)
        case didTapLogin
    }

    // MARK: - Mutation
    enum Mutation {
        case setEmail(String)
        case setPassword(String)
        case setLoading(Bool)
        case setError(String)
        case setLoginSuccess
    }

    // MARK: - State
    struct State {
        var email: String = ""
        var password: String = ""

        var isLoading: Bool = false
        var errorMessage: String?
        @Pulse var loginSucceeded: Bool = false

        var canLogin: Bool {
            !email.isEmpty && !password.isEmpty
        }
    }

    // MARK: - Properties
    let initialState: State
    private let useCase: AuthUseCaseProtocol

    // MARK: - Initialization
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State()
    }

    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateEmail(let email):
            return .just(.setEmail(email))

        case .updatePassword(let password):
            return .just(.setPassword(password))

        case .didTapLogin:
            return performLogin()
        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setEmail(let email):
            newState.email = email

        case .setPassword(let password):
            newState.password = password

        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            newState.errorMessage = nil

        case .setError(let message):
            newState.isLoading = false
            newState.errorMessage = message

        case .setLoginSuccess:
            newState.isLoading = false
            newState.loginSucceeded = true
        }

        return newState
    }

    // MARK: - Private Methods

    private func performLogin() -> Observable<Mutation> {
        guard currentState.canLogin else {
            return .just(.setError("이메일과 비밀번호를 입력해주세요"))
        }

        // FCM 토큰 가져오기
        let deviceToken = Messaging.messaging().fcmToken

        return Observable.concat([
            .just(.setLoading(true)),

            useCase.login(
                email: currentState.email,
                password: currentState.password,
                deviceToken: deviceToken
            )
            .asObservable()
            .map { _ in Mutation.setLoginSuccess }
            .catch { error in
                let message = (error as? AuthError)?.localizedDescription ?? "로그인에 실패했습니다"
                return .concat([
                    .just(.setError(message)),
                    .just(.setLoading(false))
                ])
            }
        ])
    }
}
