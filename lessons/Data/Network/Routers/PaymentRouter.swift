//
//  PaymentRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 결제 API Router
enum PaymentRouter {
    /// 결제 검증
    case validate(PaymentValidationRequest)

    /// 결제 영수증 조회
    case fetchReceipt(orderCode: String)
}

// MARK: - Router

extension PaymentRouter: Router {

    var path: String {
        switch self {
        case .validate:
            return "/v1/payments/validation"
        case .fetchReceipt(let orderCode):
            return "/v1/payments/\(orderCode)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .validate:
            return .post
        case .fetchReceipt:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .validate(let request):
            return request.toDictionary()
        case .fetchReceipt:
            return nil
        }
    }
}

// MARK: - Request Models

/// 결제 검증 요청
struct PaymentValidationRequest: Encodable {
    let impUid: String
    let orderCode: String

    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case orderCode = "order_code"
    }
}
