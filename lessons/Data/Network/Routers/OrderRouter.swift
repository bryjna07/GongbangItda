//
//  OrderRouter.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation
import Alamofire

/// 주문 API Router
enum OrderRouter {
    /// 주문 생성
    case create(CreateOrderRequest)

    /// 내 주문 목록 조회
    case fetchMyOrders
}

// MARK: - Router

extension OrderRouter: Router {

    var path: String {
        switch self {
        case .create, .fetchMyOrders:
            return "/v1/orders"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .fetchMyOrders:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .create(let request):
            return request.toDictionary()
        case .fetchMyOrders:
            return nil
        }
    }
}

// MARK: - Request Models

/// 주문 생성 요청
struct CreateOrderRequest: Encodable {
    let activityId: String
    let reservationItemName: String
    let reservationItemTime: String
    let participantCount: Int

    enum CodingKeys: String, CodingKey {
        case activityId = "activity_id"
        case reservationItemName = "reservation_item_name"
        case reservationItemTime = "reservation_item_time"
        case participantCount = "participant_count"
    }

    init(
        gongbangId: String,
        itemName: String,
        itemTime: String,
        participantCount: Int
    ) {
        self.activityId = gongbangId
        self.reservationItemName = itemName
        self.reservationItemTime = itemTime
        self.participantCount = participantCount
    }
}
