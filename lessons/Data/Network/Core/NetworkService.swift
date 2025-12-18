//
//  NetworkService.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - NetworkService

final class NetworkService: NetworkServiceProtocol {

    // MARK: - Properties

    private let session: Session

    // MARK: - Initialization
    init(session: Session? = nil) {
        self.session = session ?? NetworkService.createSession()
    }

    // MARK: - Public Methods

    /// JSON 응답 요청
    func request<T: Decodable>(_ router: Router) -> Single<T> {
        return Single.create { [weak self] observer in
            guard let self else {
                observer(.failure(NetworkError.unknown))
                return Disposables.create()
            }

            let request = self.session.request(router)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer(.success(data))

                    case .failure(let error):
                        let networkError = self.handleError(error, response: response.response, data: response.data)
                        observer(.failure(networkError))
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    /// 응답 없는 요청 (204 No Content 등)
    func requestWithoutResponse(_ router: Router) -> Single<Void> {
        return Single.create { [weak self] observer in
            guard let self else {
                observer(.failure(NetworkError.unknown))
                return Disposables.create()
            }

            let request = self.session.request(router)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success:
                        observer(.success(()))

                    case .failure(let error):
                        let networkError = self.handleError(error, response: response.response, data: response.data)
                        observer(.failure(networkError))
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    /// Multipart 파일 업로드
    func upload<T: Decodable>(_ router: Router, multipartFormData: @escaping (MultipartFormData) -> Void) -> Single<T> {
        return Single.create { [weak self] observer in
            guard let self else {
                observer(.failure(NetworkError.unknown))
                return Disposables.create()
            }

            let request = self.session.upload(
                multipartFormData: multipartFormData,
                with: router
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    observer(.success(data))

                case .failure(let error):
                    let networkError = self.handleError(error, response: response.response, data: response.data)
                    observer(.failure(networkError))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    // MARK: - Private Methods

    /// Session 생성 (Interceptor 포함)
    private static func createSession() -> Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        return Session(
            configuration: configuration,
            interceptor: AuthInterceptor.shared,
            eventMonitors: [NetworkLogger()]
        )
    }

    /// 에러 핸들링
    private func handleError(_ error: AFError, response: HTTPURLResponse?, data: Data?) -> NetworkError {
        // HTTP 상태 코드가 있으면 우선 처리
        if let statusCode = response?.statusCode {
            return NetworkError.from(statusCode: statusCode, data: data)
        }

        // AFError 변환
        return NetworkError.from(afError: error)
    }
}

// MARK: - Network Logger (Debug)

/// Alamofire EventMonitor 기반 네트워크 로거
final class NetworkLogger: EventMonitor {

    func requestDidFinish(_ request: Request) {
        #if DEBUG
        let method = request.request?.method?.rawValue ?? "UNKNOWN"
        let url = request.request?.url?.absoluteString ?? "Unknown URL"

        Log.Network.request("[\(method)] \(url)")

        if let headers = request.request?.headers, !headers.isEmpty {
            let headerString = headers.map { "\($0.name): \($0.value)" }.joined(separator: ", ")
            Log.debug("Headers: \(headerString)")
        }

        if let body = request.request?.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            Log.debug("Body: \(bodyString)")
        }
        #endif
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let statusCode = response.response?.statusCode else { return }
        let url = request.request?.url?.absoluteString ?? "Unknown URL"

        let message = "[\(statusCode)] \(url)"

        if (200..<300).contains(statusCode) {
            Log.Network.response(message)

            #if DEBUG
            // JSON Pretty Print (DEBUG 전용)
            if let data = response.data,
               let json = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                Log.debug("Response JSON:\n\(prettyString)")
            }
            #endif
        } else {
            Log.Network.error(message)

            // 에러 응답 본문 출력
            if let data = response.data,
               let errorBody = String(data: data, encoding: .utf8) {
                Log.Network.error("Error Body: \(errorBody)")
            }
        }
    }
}
