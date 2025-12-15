//
//  BaseListCell.swift
//  lessons
//
//  Created by Watson22_YJ on 12/12/25.
//

import UIKit

//MARK: - UICollectionViewListCell
class BaseListCell: UICollectionViewListCell {
    
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

extension BaseListCell: ConfigureUI {
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() {
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .systemBackground
        backgroundConfiguration = background
    }
}
