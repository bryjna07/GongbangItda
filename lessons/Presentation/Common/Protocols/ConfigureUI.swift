//
//  ConfigureUI.swift
//  lessons
//
//  Created by Watson22_YJ on 12/12/25.
//

import Foundation

/// UI 설정을 위한 공통 프로토콜
@objc protocol ConfigureUI: AnyObject {
    /// 뷰 계층 구성 (addSubview)
    func configureHierarchy()
    /// 레이아웃 제약조건 설정 (SnapKit)
    func configureLayout()
    /// 뷰 속성 설정 (색상, 폰트 등)
    func configureView()
}
