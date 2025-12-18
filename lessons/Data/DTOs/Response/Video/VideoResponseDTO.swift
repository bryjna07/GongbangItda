//
//  VideoResponseDTO.swift
//  lessons
//
//  Created by Watson22_YJ on 12/17/25.
//

import Foundation

// MARK: - Video List Response
struct VideoListResponseDTO: Decodable {
    let data: [VideoDTO]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

// MARK: - Video DTO
struct VideoDTO: Decodable {
    let videoId: String
    let fileName: String
    let title: String
    let description: String
    let duration: Double
    let thumbnailUrl: String
    let availableQualities: [String]
    let viewCount: Int
    let likeCount: Int
    let isLiked: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case videoId = "video_id"
        case fileName = "file_name"
        case title
        case description
        case duration
        case thumbnailUrl = "thumbnail_url"
        case availableQualities = "available_qualities"
        case viewCount = "view_count"
        case likeCount = "like_count"
        case isLiked = "is_liked"
        case createdAt
    }
}

// MARK: - Video Stream Response
struct VideoStreamResponseDTO: Decodable {
    let videoId: String
    let streamUrl: String
    let qualities: [VideoQualityDTO]
    let subtitles: [VideoSubtitleDTO]

    enum CodingKeys: String, CodingKey {
        case videoId = "video_id"
        case streamUrl = "stream_url"
        case qualities
        case subtitles
    }
}

// MARK: - Video Quality DTO
struct VideoQualityDTO: Decodable {
    let quality: String
    let url: String
}

// MARK: - Video Subtitle DTO
struct VideoSubtitleDTO: Decodable {
    let language: String
    let name: String
    let isDefault: Bool
    let url: String

    enum CodingKeys: String, CodingKey {
        case language
        case name
        case isDefault = "is_default"
        case url
    }
}

// MARK: - Video Like Toggle Response
struct VideoLikeToggleResponseDTO: Decodable {
    let likeStatus: Bool

    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
