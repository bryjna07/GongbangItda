//
//  AuthInterceptor.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

// MARK: - AuthInterceptor

final class AuthInterceptor: RequestInterceptor {

    // MARK: - Singleton

    static let shared = AuthInterceptor()

    // MARK: - Initialization

    private init() {}

    // MARK: - Properties

    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []

    // MARK: - Adapt

    /// 요청에 Access Token 주입
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

        // 토큰 갱신 API는 별도 처리 (헤더 구조가 다름)
        if request.url?.path.contains("/auth/refresh") == true {
            completion(.success(request))
            return
        }

        // Access Token 주입
        if let token = KeychainManager.loadAccessToken() {
            request.headers.add(.authorization(token))
        }

        completion(.success(request))
    }

    // MARK: - Retry

    /// 419 에러 시 토큰 갱신 후 재시도
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 419 else {
            completion(.doNotRetry)
            return
        }

        // 이미 갱신 중이면 대기열에 추가
        requestsToRetry.append(completion)

        guard !isRefreshing else { return }
        isRefreshing = true

        refreshToken { [weak self] result in
            guard let self else { return }

            self.isRefreshing = false

            switch result {
            case .success:
                // 대기 중인 모든 요청 재시도
                self.requestsToRetry.forEach { $0(.retry) }

            case .failure:
                // 갱신 실패 시 모든 요청 실패 처리
                self.requestsToRetry.forEach { $0(.doNotRetry) }
            }

            self.requestsToRetry.removeAll()
        }
    }

    // MARK: - Private Methods

    /// 토큰 갱신
    private func refreshToken(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let accessToken = KeychainManager.loadAccessToken(),
              let refreshToken = KeychainManager.loadRefreshToken() else {
            completion(.failure(.unauthorized))
            return
        }

        let url = Secret.baseURL + "/v1/auth/refresh"

        let headers: HTTPHeaders = [
            .contentType,
            .apiKey,
            .authorization(accessToken),
            .refreshToken(refreshToken)
        ]

        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TokenPairDTO.self) { response in
                switch response.result {
                case .success(let tokens):
                    // 새 토큰 저장
                    KeychainManager.saveAccessToken(tokens.accessToken)
                    KeychainManager.saveRefreshToken(tokens.refreshToken)
                    Log.Network.response("토큰 갱신 성공")
                    completion(.success(()))

                case .failure(let error):
                    // 418: Refresh Token 만료 → 로그아웃
                    if let statusCode = response.response?.statusCode, statusCode == 418 {
                        KeychainManager.deleteAll()
                        NotificationCenter.default.post(name: .sessionExpired, object: nil)
                        Log.Network.error("Refresh Token 만료 (418)")
                        completion(.failure(.refreshTokenExpired))
                    } else {
                        Log.Network.error("토큰 갱신 실패: \(error.localizedDescription)")
                        completion(.failure(.from(afError: error)))
                    }
                }
            }
    }
}

// MARK: - Notification

extension Notification.Name {
    /// 세션 만료 알림 (418: Refresh Token 만료)
    static let sessionExpired = Notification.Name("sessionExpired")
}
