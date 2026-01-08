//
//  ProfileReactor.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import Foundation
import RxSwift
import ReactorKit

final class ProfileReactor: Reactor {

    // MARK: - Action
    enum Action {
        case viewWillAppear
        case didTapSetting
        case didSelectImageData(Data)  // UIImage 대신 Data 사용 (UIKit 의존성 제거)
        case didTapEditButton
        case didConfirmEdit(nickname: String?, phoneNumber: String?, introduction: String?)
        case didConfirmLogout
    }

    // MARK: - Mutation
    enum Mutation {
        case setLoading(Bool)
        case setProfile(User)
        case setProfileImage(String)
        case setError(String)
        case showLogoutAlert
        case showEditModal
        case logoutCompleted
    }

    // MARK: - State
    struct State {
        var isLoading: Bool = false
        var user: User?
        var errorMessage: String?

        @Pulse var showLogoutAlert: Bool = false
        @Pulse var showEditModal: Bool = false
        @Pulse var logoutCompleted: Bool = false
    }

    // MARK: - Properties
    let initialState: State
    private let useCase: ProfileUseCaseProtocol

    // MARK: - Initialization
    init(useCase: ProfileUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State()
    }

    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchProfile()

        case .didTapSetting:
            return .just(.showLogoutAlert)

        case .didSelectImageData(let imageData):
            return uploadProfileImage(imageData)

        case .didTapEditButton:
            return .just(.showEditModal)

        case .didConfirmEdit(let nickname, let phoneNumber, let introduction):
            return updateProfile(nickname: nickname, phoneNumber: phoneNumber, introduction: introduction)

        case .didConfirmLogout:
            return performLogout()
        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            newState.errorMessage = nil

        case .setProfile(let user):
            newState.isLoading = false
            newState.user = user

        case .setProfileImage(let imageURL):
            // 프로필 이미지 URL 업데이트
            if let user = newState.user {
                newState.user = User(
                    id: user.id,
                    email: user.email,
                    nickname: user.nickname,
                    profileImageURL: imageURL,
                    phoneNumber: user.phoneNumber,
                    introduction: user.introduction
                )
            }

        case .setError(let message):
            newState.isLoading = false
            newState.errorMessage = message

        case .showLogoutAlert:
            newState.showLogoutAlert = true

        case .showEditModal:
            newState.showEditModal = true

        case .logoutCompleted:
            newState.logoutCompleted = true
        }

        return newState
    }

    // MARK: - Private Methods

    private func fetchProfile() -> Observable<Mutation> {
        return Observable.concat([
            .just(.setLoading(true)),

            useCase.fetchMyProfile()
                .asObservable()
                .map { Mutation.setProfile($0) }
                .catch { error in
                    let message = (error as? NetworkError)?.localizedDescription ?? "프로필 조회에 실패했습니다"
                    return .concat([
                        .just(.setError(message)),
                        .just(.setLoading(false))
                    ])
                }
        ])
    }

    /// 이미지 업로드 (ViewController에서 압축된 Data를 받음)
    private func uploadProfileImage(_ imageData: Data) -> Observable<Mutation> {
        return Observable.concat([
            .just(.setLoading(true)),

            // 1. 이미지 업로드
            useCase.uploadProfileImage(imageData: imageData)
                .asObservable()
                .flatMap { [weak self] imageURL -> Observable<Mutation> in
                    guard let self = self else { return .empty() }

                    // 2. 업로드된 이미지 경로로 프로필 업데이트 (서버에 저장)
                    return self.useCase.updateProfile(
                        nickname: nil,
                        phoneNumber: nil,
                        introduction: nil,
                        profileImage: imageURL
                    )
                    .asObservable()
                    .map { Mutation.setProfile($0) }
                }
                .catch { error in
                    let message = (error as? NetworkError)?.localizedDescription ?? "이미지 업로드에 실패했습니다"
                    return .concat([
                        .just(.setError(message)),
                        .just(.setLoading(false))
                    ])
                }
        ])
    }

    private func updateProfile(
        nickname: String?,
        phoneNumber: String?,
        introduction: String?
    ) -> Observable<Mutation> {
        // 현재 프로필 이미지 경로 유지
        let currentProfileImage = currentState.user?.profileImageURL

        return Observable.concat([
            .just(.setLoading(true)),

            useCase.updateProfile(
                nickname: nickname,
                phoneNumber: phoneNumber,
                introduction: introduction,
                profileImage: currentProfileImage
            )
            .asObservable()
            .map { Mutation.setProfile($0) }
            .catch { error in
                let message = (error as? NetworkError)?.localizedDescription ?? "프로필 수정에 실패했습니다"
                return .concat([
                    .just(.setError(message)),
                    .just(.setLoading(false))
                ])
            }
        ])
    }

    /// 로그아웃 수행 (Action → Mutation 흐름 준수)
    private func performLogout() -> Observable<Mutation> {
        return useCase.logout()
            .asObservable()
            .map { _ in Mutation.logoutCompleted }
            .catch { _ in
                // 로그아웃 실패해도 화면 전환 (UseCase에서 토큰 삭제 처리)
                return .just(.logoutCompleted)
            }
    }
}
