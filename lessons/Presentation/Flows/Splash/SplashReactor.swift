//
//  SplashReactor.swift
//  lessons
//
//  Created by Watson22_YJ on 12/23/25.
//

import Foundation
import RxSwift
import ReactorKit

/// Splash 화면 상태 관리
/// - 토큰 유효성 검증 후 화면 전환 결정
final class SplashReactor: Reactor {

    // MARK: - Action
    enum Action {
        /// 화면 진입 시 토큰 검증 시작
        case checkAuthState
    }

    // MARK: - Mutation
    enum Mutation {
        /// 인증 완료 (홈 화면으로 이동)
        case setAuthenticated
        /// 인증 필요 (로그인 화면으로 이동)
        case setUnauthenticated
    }

    // MARK: - State
    struct State {
        /// 인증 상태 확인 결과 (nil: 확인 중, true: 인증됨, false: 미인증)
        @Pulse var authResult: Bool?
    }

    // MARK: - Properties
    let initialState: State
    private let authUseCase: AuthUseCaseProtocol

    // MARK: - Initialization
    init(authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase
        self.initialState = State()
    }

    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkAuthState:
            return checkAuthState()
        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setAuthenticated:
            newState.authResult = true

        case .setUnauthenticated:
            newState.authResult = false
        }

        return newState
    }

    // MARK: - Private Methods

    /// 토큰 존재 여부 확인 및 갱신 시도
    private func checkAuthState() -> Observable<Mutation> {
        let hasAccessToken = KeychainManager.loadAccessToken() != nil
        let hasRefreshToken = KeychainManager.loadRefreshToken() != nil

        // 토큰이 없으면 바로 미인증
        guard hasAccessToken && hasRefreshToken else {
            Log.info("저장된 토큰 없음 - 로그인 화면으로 이동")
            return .just(.setUnauthenticated)
        }

        // 토큰 존재 시 갱신 API로 유효성 검증
        Log.info("저장된 토큰 발견 - 유효성 검증 중...")

        return authUseCase.refreshToken()
            .asObservable()
            .map { _ -> Mutation in
                Log.info("토큰 유효성 검증 성공 - 홈화면으로 이동")
                return .setAuthenticated
            }
            .catch { error -> Observable<Mutation> in
                Log.info("토큰 유효성 검증 실패: \(error.localizedDescription)")
                // 토큰 삭제
                KeychainManager.deleteAll()
                return .just(.setUnauthenticated)
            }
    }
}
