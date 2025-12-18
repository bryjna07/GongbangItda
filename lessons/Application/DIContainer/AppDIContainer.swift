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
        // MARK: - Network
        // TODO: Network 계층 구현 시 등록

        // MARK: - Repositories
        // TODO: Repository 구현 시 등록

        // MARK: - UseCases
        // TODO: UseCase 구현 시 등록

        // MARK: - Coordinators
        // TODO: Coordinator 구현 시 등록
    }
}
