//
//  BaseView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/12/25.
//

import UIKit

//MARK: - BaseView
class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseView: ConfigureUI {
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() {
        backgroundColor = .systemBackground
    }
}
