//
//  GISize.swift
//  lessons
//
//  Created by Watson22_YJ on 12/29/25.
//

import CoreGraphics

/// 디자인 시스템 사이즈 상수
enum GISize {

    // MARK: - Profile

    /// 프로필 이미지 컨테이너 사이즈: 120pt
    static let profileImageContainer: CGFloat = 120

    /// 프로필 이미지 cornerRadius (정원): 60pt
    static let profileImageRadius: CGFloat = 60

    /// 카메라 버튼 사이즈: 32pt
    static let cameraButton: CGFloat = 32

    /// 카메라 버튼 cornerRadius (정원): 16pt
    static let cameraButtonRadius: CGFloat = 16

    // MARK: - Icons

    /// 통계 아이콘 사이즈: 24pt
    static let statsIcon: CGFloat = 24

    // MARK: - Social Login

    /// 소셜 로그인 버튼 사이즈: 56pt
    static let socialLoginButton: CGFloat = 56

    /// 소셜 로그인 버튼 cornerRadius (정원): 28pt
    static let socialLoginButtonRadius: CGFloat = 28

    // MARK: - TextField

    /// TextField 기본 높이: 50pt
    static let textFieldHeight: CGFloat = 50

    /// TextView 기본 높이: 100pt
    static let textViewHeight: CGFloat = 100

    // MARK: - Buttons

    /// 이메일 중복확인 버튼 너비: 90pt
    static let emailCheckButtonWidth: CGFloat = 90

    // MARK: - Divider

    /// 디바이더 너비: 1pt
    static let dividerWidth: CGFloat = 1
}
