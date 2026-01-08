//
//  SplashDIContainer.swift
//  lessons
//
//  Created by Watson22_YJ on 12/23/25.
//

import UIKit
import Swinject

/// Splash 화면 전용 의존성 주입 컨테이너
final class SplashDIContainer {

    private let container: Container

    init(container: Container) {
        self.container = container
    }

    // MARK: - SplashViewController Factory

    /// SplashViewController 생성
    func makeSplashViewController() -> SplashViewController {
        guard let reactor = container.resolve(SplashReactor.self) else {
            fatalError("SplashReactor not registered in DIContainer")
        }

        return SplashViewController(reactor: reactor)
    }

    // MARK: - Dependency Registration

    /// Splash 관련 의존성 등록
    static func register(in container: Container) {
        // SplashReactor (AuthUseCase 의존)
        container.register(SplashReactor.self) { resolver in
            guard let authUseCase = resolver.resolve(AuthUseCaseProtocol.self) else {
                fatalError("AuthUseCaseProtocol dependency not resolved")
            }
            return SplashReactor(authUseCase: authUseCase)
        }
    }
}
