//
//  ProfileDIContainer.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import Swinject

/// 프로필 화면 전용 의존성 주입 컨테이너
final class ProfileDIContainer {

    private let container: Container

    init(container: Container) {
        self.container = container
    }

    // MARK: - Factory Methods

    /// ProfileViewController 생성 (Coordinator에서 호출)
    func makeProfileViewController() -> ProfileViewController {
        guard let reactor = container.resolve(ProfileReactor.self) else {
            fatalError("ProfileReactor not registered in DIContainer")
        }

        return ProfileViewController(reactor: reactor)
    }

    // MARK: - Dependency Registration

    /// 프로필 관련 의존성 등록
    static func register(in container: Container) {
        // Repositories (Network와 Auth는 AppDIContainer에서 이미 등록됨)
        container.register(UserRepositoryProtocol.self) { resolver in
            guard let networkService = resolver.resolve(NetworkServiceProtocol.self) else {
                fatalError("NetworkServiceProtocol dependency not resolved")
            }
            return UserRepository(networkService: networkService)
        }.inObjectScope(.container)

        // UseCases
        container.register(ProfileUseCaseProtocol.self) { resolver in
            guard let userRepository = resolver.resolve(UserRepositoryProtocol.self),
                  let authRepository = resolver.resolve(AuthRepositoryProtocol.self) else {
                fatalError("Repository dependencies not resolved")
            }
            return ProfileUseCase(
                userRepository: userRepository,
                authRepository: authRepository
            )
        }

        // Reactors
        container.register(ProfileReactor.self) { resolver in
            guard let useCase = resolver.resolve(ProfileUseCaseProtocol.self) else {
                fatalError("ProfileUseCaseProtocol dependency not resolved")
            }
            return ProfileReactor(useCase: useCase)
        }
    }
}
