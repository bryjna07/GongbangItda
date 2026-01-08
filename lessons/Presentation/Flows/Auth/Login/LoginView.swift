//
//  LoginView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit
import SnapKit
import Then

final class LoginView: BaseView {
    
    // MARK: - UI Components
    
    /// 상단 배경 영역
    private let topBackgroundView = UIView()
    
    /// 하단 흰색 영역
    private let bottomContainerView = UIView()
    
    /// 소셜 로그인 버튼 스택
    private let socialButtonStackView = UIStackView()
    
    /// 카카오 로그인 버튼
    let kakaoLoginButton = UIButton()

    /// 애플 로그인 버튼
    let appleLoginButton = UIButton()
    
    /// 이메일 로그인 버튼
    let emailLoginButton = UIButton()
    
    /// 회원가입 버튼
    let signUpButton = UIButton()
    
    
    // MARK: - Configuration
    
    override func configureHierarchy() {
        [
            topBackgroundView,
            bottomContainerView
        ].forEach { addSubview($0) }

        [
            socialButtonStackView,
            signUpButton
        ].forEach { bottomContainerView.addSubview($0) }

        [
            kakaoLoginButton, emailLoginButton, appleLoginButton
        ].forEach { socialButtonStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        topBackgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.55)
        }

        bottomContainerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(topBackgroundView.snp.bottom).offset(-GISpacing.xxl)
        }

        socialButtonStackView.snp.makeConstraints {
            $0.bottom.equalTo(bottomContainerView.snp.centerY)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(GISize.socialLoginButton)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(socialButtonStackView.snp.bottom).offset(GISpacing.xxl)
            $0.centerX.equalToSuperview()
        }

        [
            kakaoLoginButton, emailLoginButton, appleLoginButton
        ].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(GISize.socialLoginButton)
            }
        }
    }
    
    override func configureView() {
        super.configureView()
        
        topBackgroundView.do {
            $0.backgroundColor = .deepSeafoam
        }
        
        bottomContainerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = GISpacing.xxl
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        socialButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = GISpacing.xxl
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }

        // TODO: - 카카오 연동 후 수정
        kakaoLoginButton.do {
            $0.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0, alpha: 1)
            $0.layer.cornerRadius = GISize.socialLoginButtonRadius
            $0.setImage(.icon(GIIcons.kakaoMessage), for: .normal)
            $0.tintColor = .black
        }

        appleLoginButton.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = GISize.socialLoginButtonRadius
            $0.setImage(.icon(GIIcons.appleLogo), for: .normal)
            $0.tintColor = .white
        }

        emailLoginButton.do {
            $0.backgroundColor = .deepSeafoam
            $0.layer.cornerRadius = GISize.socialLoginButtonRadius
            $0.setImage(.icon(GIIcons.pencil), for: .normal)
            $0.tintColor = .white
        }

        signUpButton.do {
            $0.setTitle(GIStrings.Auth.signUpWithEmail, for: .normal)
            $0.setTitleColor(.gray, for: .normal)
            $0.titleLabel?.font = GIFonts.body2
        }
    }
}
