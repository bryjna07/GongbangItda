//
//  Router.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

// MARK: - Router Protocol

/// API Router 프로토콜
/// - URLRequestConvertible 채택으로 Alamofire와 통합
/// - 각 API별 Router에서 구현
protocol Router: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

// MARK: - Default Implementation

extension Router {

    var baseURL: String {
        return Secret.baseURL
    }

    var headers: HTTPHeaders {
        return HTTPHeaders([
            HTTPHeader.contentType,
            HTTPHeader.apiKey
        ])
    }

    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers

        if let parameters = parameters {
            request = try encoding.encode(request, with: parameters)
        }

        return request
    }
}

// MARK: - HTTPHeader Extensions

extension HTTPHeader {

    static var contentType: HTTPHeader {
        HTTPHeader(name: "Content-Type", value: "application/json")
    }

    static var apiKey: HTTPHeader {
        HTTPHeader(name: "SeSACKey", value: Secret.apiKey)
    }

    static func authorization(_ token: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: token)
    }

    static func refreshToken(_ token: String) -> HTTPHeader {
        HTTPHeader(name: "RefreshToken", value: token)
    }
}
