//
//  NetworkServiceProtocol.swift
//  lessons
//
//  Created by Watson22_YJ on 12/18/25.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - Protocol

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ router: Router) -> Single<T>
    func requestWithoutResponse(_ router: Router) -> Single<Void>
    func upload<T: Decodable>(_ router: Router, multipartFormData: @escaping (MultipartFormData) -> Void) -> Single<T>
}
