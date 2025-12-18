//
//  UICollectionView+ReusableView.swift
//  lessons
//
//  Created by Watson22_YJ on 12/12/25.
//

import UIKit

// MARK: - UICollectionView + Register & Dequeue
extension UICollectionView {

    // MARK: - Cell Registration
    
    /// 셀 등록 (reuseIdentifier 자동 생성)
    /// - Parameter cell: 등록할 셀 타입
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    // MARK: - Cell Dequeue
    
    /// 셀 재사용 (타입 캐스팅 자동)
    /// - Parameter indexPath: IndexPath
    /// - Returns: 재사용된 셀
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue cell: \(T.reuseIdentifier)")
        }
        return cell
    }

    // MARK: - Supplementary Registration
    
    /// Header 등록
    func register<T: UICollectionReusableView>(header: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseIdentifier
        )
    }

    /// Footer 등록
    func register<T: UICollectionReusableView>(footer: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.reuseIdentifier
        )
    }

    /// Custom Supplementary View 등록 (elementKind 자동 생성)
    func register<T: UICollectionReusableView>(supplementary: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: T.elementKind,
            withReuseIdentifier: T.reuseIdentifier
        )
    }
    
    /// Custom Supplementary View 등록 (elementKind 직접 지정)
    func register<T: UICollectionReusableView>(supplementary: T.Type, kind: String) {
        register(
            T.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.reuseIdentifier
        )
    }

    // MARK: - Supplementary Dequeue
    
    /// Header 재사용
    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue header: \(T.reuseIdentifier)")
        }
        return view
    }

    /// Footer 재사용
    func dequeueFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue footer: \(T.reuseIdentifier)")
        }
        return view
    }

    /// Custom Supplementary View 재사용
    func dequeueSupplementary<T: UICollectionReusableView>(kind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue supplementary: \(T.reuseIdentifier)")
        }
        return view
    }
}
