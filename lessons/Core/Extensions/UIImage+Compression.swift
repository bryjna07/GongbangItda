//
//  UIImage+Compression.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit

extension UIImage {

    /// 이미지를 JPEG로 압축 (최대 용량 제한)
    /// - Parameters:
    ///   - maxSizeInBytes: 최대 용량 (기본값: 1MB - 서버 제한)
    ///   - initialQuality: 초기 압축 품질 (기본값: 0.8)
    /// - Returns: 압축된 이미지 데이터
    ///
    /// - Note: 프로필 이미지는 ProfileView의 profileImageView 크기(120x120)에 최적화
    ///         레티나 디스플레이 @3x 고려 시 512x512 크기로 리사이즈
    func compressToJPEG(maxSizeInBytes: Int = 1024 * 1024, initialQuality: CGFloat = 0.8) -> Data? {
        var quality = initialQuality
        var imageData = self.jpegData(compressionQuality: quality)

        // 용량이 초과하면 품질을 낮춰가며 압축
        while let data = imageData, data.count > maxSizeInBytes, quality > 0.1 {
            quality -= 0.1
            imageData = self.jpegData(compressionQuality: quality)
        }

        // 최종 압축 후에도 용량 초과 시 이미지 리사이즈
        if let data = imageData, data.count > maxSizeInBytes {
            let resizedImage = self.resized(toMaxDimension: 512) // 프로필 이미지 최적 크기
            return resizedImage?.compressToJPEG(maxSizeInBytes: maxSizeInBytes, initialQuality: 0.7)
        }

        return imageData
    }

    /// 이미지 리사이즈 (최대 크기 제한)
    /// - Parameter maxDimension: 최대 가로/세로 크기
    /// - Returns: 리사이즈된 이미지
    func resized(toMaxDimension maxDimension: CGFloat) -> UIImage? {
        let ratio = min(maxDimension / size.width, maxDimension / size.height)

        // 이미 작으면 그대로 반환
        guard ratio < 1 else { return self }

        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
