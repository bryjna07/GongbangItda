//
//  NetworkError.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

// MARK: - NetworkError

/// 네트워크 에러 타입
/// - API 명세 기반 HTTP 상태 코드 분류
enum NetworkError: Error, Equatable {

    // MARK: - HTTP Status Code Errors

    case badRequest(message: String?)       // 400
    case unauthorized                       // 401
    case forbidden                          // 403
    case notFound                           // 404
    case conflict(message: String?)          // 409
    case refreshTokenExpired                // 418
    case tokenExpired                       // 419
    case invalidAPIKey                      // 420
    case tooManyRequests                    // 429
    case abnormalRequest                    // 444
    case permissionDenied(message: String?) // 445
    case serverError(statusCode: Int, message: String?) // 500~599

    // MARK: - Client Errors

    case invalidURL
    case decodingFailed
    case encodingFailed

    // MARK: - Network Errors

    case noConnection
    case timeout
    case unknown
}

// MARK: - LocalizedError

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .badRequest(let message):
            return message ?? "잘못된 요청입니다."
        case .unauthorized:
            return "로그인이 필요합니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "요청한 정보를 찾을 수 없습니다."
        case .conflict(let message):
            return message ?? "이미 처리된 요청입니다."
        case .refreshTokenExpired:
            return "로그인이 만료되었습니다. 다시 로그인해주세요."
        case .tokenExpired:
            return "인증이 만료되었습니다."
        case .invalidAPIKey:
            return "앱 인증에 실패했습니다. 앱을 재설치해주세요."
        case .tooManyRequests:
            return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."
        case .abnormalRequest:
            return "비정상적인 요청입니다."
        case .permissionDenied(let message):
            return message ?? "권한이 없습니다."
        case .serverError(_, let message):
            return message ?? "서버 오류가 발생했습니다."
        case .invalidURL:
            return "잘못된 요청 주소입니다."
        case .decodingFailed:
            return "데이터 처리에 실패했습니다."
        case .encodingFailed:
            return "요청 생성에 실패했습니다."
        case .noConnection:
            return "네트워크 연결을 확인해주세요."
        case .timeout:
            return "요청 시간이 초과되었습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

// MARK: - Status Code Factory

extension NetworkError {

    /// HTTP 상태 코드로부터 NetworkError 생성
    static func from(statusCode: Int, data: Data?) -> NetworkError {
        let message = parseMessage(from: data)

        switch statusCode {
        case 400: return .badRequest(message: message)
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 409: return .conflict(message: message)
        case 418: return .refreshTokenExpired
        case 419: return .tokenExpired
        case 420: return .invalidAPIKey
        case 429: return .tooManyRequests
        case 444: return .abnormalRequest
        case 445: return .permissionDenied(message: message)
        case 500...599: return .serverError(statusCode: statusCode, message: message)
        default: return .unknown
        }
    }

    /// AFError로부터 NetworkError 생성
    static func from(afError: AFError) -> NetworkError {
        // NetworkLogger가 원본 AFError를 로깅하므로, 연관값 없이 간단히 분류만
        switch afError {
        case .responseValidationFailed(let reason):
            // HTTP 상태 코드 에러
            if case .unacceptableStatusCode(let code) = reason {
                return .from(statusCode: code, data: nil)
            }
            return .unknown

        case .sessionTaskFailed(let error):
            // 네트워크 연결/타임아웃 에러
            let nsError = error as NSError
            switch nsError.code {
            case NSURLErrorTimedOut:
                return .timeout
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
                return .noConnection
            default:
                return .unknown
            }

        case .responseSerializationFailed:
            // JSON 디코딩 실패
            return .decodingFailed

        case .parameterEncodingFailed, .parameterEncoderFailed:
            // 파라미터 인코딩 실패
            return .encodingFailed

        case .invalidURL:
            // 잘못된 URL
            return .invalidURL

        default:
            // 그 외 모든 케이스
            return .unknown
        }
    }

    private static func parseMessage(from data: Data?) -> String? {
        guard let data = data,
              let response = try? JSONDecoder().decode(MessageResponseDTO.self, from: data) else {
            return nil
        }
        return response.message
    }
}

// MARK: - Classification

extension NetworkError {

    /// 토큰 갱신이 필요한 에러 (419)
    var requiresTokenRefresh: Bool {
        if case .tokenExpired = self { return true }
        return false
    }

    /// 로그인 화면 이동이 필요한 에러 (401, 418)
    var requiresLogin: Bool {
        switch self {
        case .unauthorized, .refreshTokenExpired:
            return true
        default:
            return false
        }
    }

    /// 재시도 가능한 에러
    var isRetryable: Bool {
        switch self {
        case .timeout, .noConnection, .serverError:
            return true
        default:
            return false
        }
    }
}
