//
//  ImageCacheConfig.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import Foundation
import Kingfisher

/// Kingfisher 이미지 캐시 설정
/// - AppDelegate에서 앱 시작 시 1회 호출
/// - 전략: 크기별 다운샘플링으로 디스크 효율 극대화
enum ImageCacheConfig {

    // MARK: - Configuration

    /// 캐시 설정 구조체 (외부에서 커스터마이징 가능)
    struct Configuration {
        /// 메모리 캐시 최대 용량 (바이트)
        let memoryCacheSize: Int
        /// 메모리 캐시 최대 개수 (이미지 개수)
        let memoryCacheCount: Int
        /// 디스크 캐시 최대 용량 (바이트)
        let diskCacheSize: UInt
        /// 디스크 캐시 기본 만료 기간 (일) - ImageCacheStrategy에서 오버라이드
        let expirationDays: Int
        /// 다운로드 타임아웃 (초)
        let downloadTimeout: TimeInterval

        /// 기본 설정
        /// - 메모리: 300MB / 150개
        /// - 디스크: 500MB (크기별 캐싱으로 원본 대비 절약)
        /// - 전략별 TTL: 썸네일 7일, 상세 1일, 배너 24시간
        static let `default` = Configuration(
            memoryCacheSize: 300 * 1024 * 1024,  // 300MB
            memoryCacheCount: 150,
            diskCacheSize: 500 * 1024 * 1024,    // 500MB (원본 캐싱 안하므로 줄임)
            expirationDays: 7,                    // 기본 TTL (전략별 오버라이드)
            downloadTimeout: 15.0
        )

        /// 작은 용량 설정 (메모리 절약 필요 시)
        /// - 메모리: 100MB / 50개
        /// - 디스크: 200MB
        static let compact = Configuration(
            memoryCacheSize: 100 * 1024 * 1024,  // 100MB
            memoryCacheCount: 50,
            diskCacheSize: 200 * 1024 * 1024,    // 200MB
            expirationDays: 3,
            downloadTimeout: 10.0
        )

        /// 이미지 많은 앱 설정
        /// - 메모리: 500MB / 250개
        /// - 디스크: 1GB (크기별 캐싱으로 충분)
        static let imageFocused = Configuration(
            memoryCacheSize: 500 * 1024 * 1024,  // 500MB
            memoryCacheCount: 250,
            diskCacheSize: 1024 * 1024 * 1024,   // 1GB
            expirationDays: 7,
            downloadTimeout: 15.0
        )
    }

    // MARK: - Setup

    static func configure(with config: Configuration = .default) {
        let cache = ImageCache.default

        // 메모리 캐시 설정
        cache.memoryStorage.config.totalCostLimit = config.memoryCacheSize
        cache.memoryStorage.config.countLimit = config.memoryCacheCount

        // 디스크 캐시 설정
        cache.diskStorage.config.sizeLimit = config.diskCacheSize
        cache.diskStorage.config.expiration = .days(config.expirationDays)

        // 백그라운드 진입 시 만료된 캐시 자동 정리
        cache.cleanExpiredDiskCache()

        // 다운로더 설정
        let downloader = ImageDownloader.default
        downloader.downloadTimeout = config.downloadTimeout

        Log.info("ImageCache 설정 완료 - Memory: \(config.memoryCacheSize / 1024 / 1024)MB/\(config.memoryCacheCount)개, Disk: \(config.diskCacheSize / 1024 / 1024)MB/\(config.expirationDays)일")
    }

    // MARK: - Cache Management

    /// 메모리 캐시 정리 (앱 백그라운드 진입 시 자동 호출)
    static func clearMemoryCache() {
        ImageCache.default.clearMemoryCache()
        Log.info("이미지 메모리 캐시 정리 완료")
    }

    /// 디스크 캐시 정리 (설정 > 캐시 삭제 기능에서 사용)
    static func clearDiskCache() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            ImageCache.default.clearDiskCache {
                Log.info("이미지 디스크 캐시 정리 완료")
                continuation.resume()
            }
        }
    }

    /// 전체 캐시 정리 (메모리 + 디스크 + ETag)
    static func clearAll() async {
        clearMemoryCache()
        await clearDiskCache()
//        ETagManager.deleteAll()
    }

    /// 디스크 캐시 사용량 조회
    /// - Returns: 캐시 사용량 (바이트)
    static func diskCacheSize() async -> UInt {
        await withCheckedContinuation { continuation in
            ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case .success(let size):
                    continuation.resume(returning: size)
                case .failure:
                    continuation.resume(returning: 0)
                }
            }
        }
    }

    /// 디스크 캐시 사용량 문자열 반환
    /// - Returns: "45.2 MB" 형태의 문자열
    static func diskCacheSizeString() async -> String {
        let size = await diskCacheSize()
        let sizeInMB = Double(size) / 1024 / 1024
        return String(format: "%.1f MB", sizeInMB)
    }
}

