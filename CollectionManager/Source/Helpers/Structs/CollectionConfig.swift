//
//  CollectionManagerConfig.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

/**
    Config structure which configuring collection view and its flow layout.
 */
public struct CollectionConfig: Config {
    let sectionInset: UIEdgeInsets
    let minimumLineSpacing: CGFloat
    let minimumInteritemSpacing: CGFloat
    let scrollDirection: UICollectionView.ScrollDirection
    let isScrollEnabled: Bool
    
    public init(
        sectionInset: UIEdgeInsets,
        minimumLineSpacing: CGFloat,
        minimumInteritemSpacing: CGFloat,
        scrollDirection: UICollectionView.ScrollDirection,
        isScrollEnabled: Bool
    ) {
        self.sectionInset = sectionInset
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.scrollDirection = scrollDirection
        self.isScrollEnabled = isScrollEnabled
    }
    
    public static var `default`: Self {
        CollectionConfig(
            sectionInset: .zero,
            minimumLineSpacing: 24,
            minimumInteritemSpacing: 12,
            scrollDirection: .vertical,
            isScrollEnabled: true
        )
    }
}
