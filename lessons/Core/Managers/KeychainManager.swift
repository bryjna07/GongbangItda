//
//  KeychainManager.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import Foundation
import Security

/// Keychain 기반 토큰 관리
enum KeychainManager {

    // MARK: - Keys

    private enum Keys {
        static let accessToken = "com.watson.lessons.accessToken"
        static let refreshToken = "com.watson.lessons.refreshToken"
    }

    // MARK: - Save

    /// AccessToken 저장
    static func saveAccessToken(_ token: String) {
        save(key: Keys.accessToken, value: token)
    }

    /// RefreshToken 저장
    static func saveRefreshToken(_ token: String) {
        save(key: Keys.refreshToken, value: token)
    }

    // MARK: - Load

    /// AccessToken 조회
    static func loadAccessToken() -> String? {
        return load(key: Keys.accessToken)
    }

    /// RefreshToken 조회
    static func loadRefreshToken() -> String? {
        return load(key: Keys.refreshToken)
    }

    // MARK: - Delete

    /// AccessToken 삭제
    static func deleteAccessToken() {
        delete(key: Keys.accessToken)
    }

    /// RefreshToken 삭제
    static func deleteRefreshToken() {
        delete(key: Keys.refreshToken)
    }

    /// 모든 토큰 삭제 (로그아웃 시)
    static func deleteAll() {
        deleteAccessToken()
        deleteRefreshToken()
        Log.info("Keychain 토큰 전체 삭제 완료")
    }

    // MARK: - Private Helpers

    /// Keychain 저장
    private static func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else {
            Log.error("Keychain 저장 실패: 데이터 변환 실패 - \(key)")
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock  // 디바이스 잠금 해제 후 접근 가능
        ]

        // 기존 항목 삭제 후 저장 (업데이트 대신 삭제+추가)
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            Log.debug("Keychain 저장 성공: \(key)")
        } else {
            Log.error("Keychain 저장 실패: \(key) - status: \(status)")
        }
    }

    /// Keychain 조회
    private static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            if status != errSecItemNotFound {
                Log.error("Keychain 조회 실패: \(key) - status: \(status)")
            }
            return nil
        }

        return value
    }

    /// Keychain 삭제
    private static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess || status == errSecItemNotFound {
            Log.debug("Keychain 삭제 성공: \(key)")
        } else {
            Log.error("Keychain 삭제 실패: \(key) - status: \(status)")
        }
    }
}
