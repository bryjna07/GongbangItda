//
//  SignUpReactor.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift
import ReactorKit

/// 회원가입 화면 상태 관리
final class SignUpReactor: Reactor {

    // MARK: - Action
    enum Action {
        case updateEmail(String)
        case updatePassword(String)
        case updateNickname(String)
        case updatePhoneNum(String)
        case updateIntroduction(String)
        case didTapEmailCheck
        case didTapSignUp
    }

    // MARK: - Mutation
    enum Mutation {
        case setEmail(String)
        case setPassword(String)
        case setNickname(String)
        case setPhoneNum(String)
        case setIntroduction(String)
        case setEmailValid(Bool)
        case setEmailChecked(Bool)
        case setLoading(Bool)
        case setError(String)
        case setSignUpSuccess
    }

    // MARK: - State
    struct State {
        var email: String = ""
        var password: String = ""
        var nickname: String = ""
        var phoneNum: String = ""
        var introduction: String = ""

        var isEmailValid: Bool = false
        var isEmailChecked: Bool = false
        var isPasswordValid: Bool = false
        var isNicknameValid: Bool = false
        var isPhoneNumValid: Bool = false

        var isLoading: Bool = false
        var errorMessage: String?
        @Pulse var signUpSucceeded: Bool = false

        var canSignUp: Bool {
            // 전화번호, 소개는 선택사항
            isEmailChecked && isPasswordValid && isNicknameValid
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
            let isValid = useCase.isValidEmailFormat(email)
            return .concat([
                .just(.setEmail(email)),
                .just(.setEmailValid(isValid)),
                .just(.setEmailChecked(false))
            ])

        case .updatePassword(let password):
            return .just(.setPassword(password))

        case .updateNickname(let nickname):
            return .just(.setNickname(nickname))

        case .updatePhoneNum(let phoneNum):
            return .just(.setPhoneNum(phoneNum))

        case .updateIntroduction(let introduction):
            return .just(.setIntroduction(introduction))

        case .didTapEmailCheck:
            return checkEmailDuplication()

        case .didTapSignUp:
            return performSignUp()
        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setEmail(let email):
            newState.email = email
            newState.isEmailValid = useCase.isValidEmailFormat(email)

        case .setPassword(let password):
            newState.password = password
            newState.isPasswordValid = useCase.isValidPassword(password)

        case .setNickname(let nickname):
            newState.nickname = nickname
            newState.isNicknameValid = useCase.isValidNickname(nickname)

        case .setPhoneNum(let phoneNum):
            newState.phoneNum = phoneNum
            newState.isPhoneNumValid = useCase.isValidPhoneNum(phoneNum)

        case .setIntroduction(let introduction):
            newState.introduction = introduction

        case .setEmailValid(let isValid):
            newState.isEmailValid = isValid

        case .setEmailChecked(let isChecked):
            newState.isEmailChecked = isChecked

        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            newState.errorMessage = nil

        case .setError(let message):
            newState.isLoading = false
            newState.errorMessage = message

        case .setSignUpSuccess:
            newState.isLoading = false
            newState.signUpSucceeded = true
        }

        return newState
    }

    // MARK: - Private Methods

    private func checkEmailDuplication() -> Observable<Mutation> {
        guard currentState.isEmailValid else {
            return .just(.setError("올바른 이메일 형식이 아닙니다"))
        }

        return Observable.concat([
            .just(.setLoading(true)),

            useCase.validateEmail(email: currentState.email)
                .asObservable()
                .flatMap { isAvailable -> Observable<Mutation> in
                    if isAvailable {
                        return .concat([
                            .just(.setEmailChecked(true)),
                            .just(.setLoading(false))
                        ])
                    } else {
                        return .concat([
                            .just(.setError("이미 사용 중인 이메일입니다")),
                            .just(.setLoading(false))
                        ])
                    }
                }
                .catch { error in
                    .concat([
                        .just(.setError("이메일 확인 중 오류가 발생했습니다")),
                        .just(.setLoading(false))
                    ])
                }
        ])
    }

    private func performSignUp() -> Observable<Mutation> {
        guard currentState.canSignUp else {
            return .just(.setError("모든 항목을 올바르게 입력해주세요"))
        }

        return Observable.concat([
            .just(.setLoading(true)),

            useCase.signUp(
                email: currentState.email,
                password: currentState.password,
                nickname: currentState.nickname,
                phoneNum: currentState.phoneNum,
                introduction: currentState.introduction
            )
            .asObservable()
            .flatMap { _ -> Observable<Mutation> in
                .just(.setSignUpSuccess)
            }
            .catch { error in
                .concat([
                    .just(.setError("회원가입 중 오류가 발생했습니다")),
                    .just(.setLoading(false))
                ])
            }
        ])
    }
}
