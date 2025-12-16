//
//  KingfisherRequestModifier.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import Foundation
import Kingfisher

/// Kingfisher 이미지 다운로드 요청 헤더
final class KingfisherRequestModifier: ImageDownloadRequestModifier {

    // MARK: - ImageDownloadRequestModifier

    func modified(for request: URLRequest) -> URLRequest? {
        var req = request

        // 1) SeSACKey 추가 (xcconfig → Info.plist)
        if let sesacKey = APIKeyManager.loadSeSACKey() {
            req.setValue(sesacKey, forHTTPHeaderField: "SeSACKey")
        } else {
            Log.error("SeSACKey 없음 - Info.plist 확인 필요")
        }

        // 2) Authorization 추가 (Keychain)
        if let accessToken = KeychainManager.loadAccessToken() {
            req.setValue(accessToken, forHTTPHeaderField: "Authorization")
        } else {
            Log.debug("AccessToken 없음 - 비로그인 상태")
        }

        // 3) ETag 추가 (304 캐싱)
//        if let url = req.url,
//           let etag = ETagManager.load(for: url) {
//            req.setValue(etag, forHTTPHeaderField: "If-None-Match")
//            Log.debug("ETag 헤더 추가: \(url.lastPathComponent) → \(etag)")
//        }

        return req
    }
}
