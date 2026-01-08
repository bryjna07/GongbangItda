//
//  AppDIContainer.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import Foundation
import Swinject

/// 앱 전역 의존성 주입 컨테이너
final class AppDIContainer {

    static let shared = AppDIContainer()
    let container: Container

    private init() {
        container = Container()
        registerDependencies()
    }

    private func registerDependencies() {
        // MARK: - Core (Network, Auth 등 공통 의존성)
        registerCoreServices()

        // MARK: - Feature Modules
        SplashDIContainer.register(in: container)
        ProfileDIContainer.register(in: container)
        // TODO: 추후 다른 화면 추가 시
        // HomeDIContainer.register(in: container)
        // SearchDIContainer.register(in: container)
        // BookmarkDIContainer.register(in: container)
    }

    /// 공통 서비스 등록 (Network, Auth 등)
    private func registerCoreServices() {
        // Network
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }.inObjectScope(.container)

        // Auth Repository (여러 곳에서 사용)
        container.register(AuthRepositoryProtocol.self) { resolver in
            guard let networkService = resolver.resolve(NetworkServiceProtocol.self) else {
                fatalError("NetworkServiceProtocol dependency not resolved")
            }
            return AuthRepository(networkService: networkService)
        }.inObjectScope(.container)

        // Auth UseCase (Splash, Auth 등에서 사용)
        container.register(AuthUseCaseProtocol.self) { resolver in
            guard let authRepository = resolver.resolve(AuthRepositoryProtocol.self) else {
                fatalError("AuthRepositoryProtocol dependency not resolved")
            }
            return AuthUseCase(repository: authRepository)
        }.inObjectScope(.container)
    }

    // MARK: - Feature DIContainers

    /// Splash 화면 DIContainer 생성
    func makeSplashDIContainer() -> SplashDIContainer {
        return SplashDIContainer(container: container)
    }

    /// Profile 화면 DIContainer 생성
    func makeProfileDIContainer() -> ProfileDIContainer {
        return ProfileDIContainer(container: container)
    }

    /// AuthUseCase 조회 (AuthCoordinator에서 사용)
    func resolveAuthUseCase() -> AuthUseCaseProtocol {
        guard let authUseCase = container.resolve(AuthUseCaseProtocol.self) else {
            fatalError("AuthUseCaseProtocol dependency not resolved")
        }
        return authUseCase
    }

    // TODO: 추후 다른 화면 추가 시
    // func makeHomeDIContainer() -> HomeDIContainer { }
    // func makeSearchDIContainer() -> SearchDIContainer { }

}
