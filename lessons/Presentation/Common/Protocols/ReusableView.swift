//
//  ReusableView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/12/25.
//

import UIKit

/// 재사용 가능한 뷰를 위한 프로토콜
protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UIView: ReusableView { }

extension UIView {
    /// Supplementary View 등록 시 사용하는 ElementKind
    static var elementKind: String {
        String(describing: self) + "ElementKind"
    }
}
