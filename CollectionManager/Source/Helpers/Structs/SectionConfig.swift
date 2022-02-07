//
//  SectionConfig.swift
//  CollectionManager
//
//  Created by 0x01eva on 25.01.2022.
//

import UIKit

/**
    Config structure which configuring collection section and its flow layout.
 */
public struct SectionConfig: Config {
    let sectionInset: UIEdgeInsets
    let minimumLineSpacing: CGFloat
    let minimumInteritemSpacing: CGFloat
    
    public init(
        sectionInset: UIEdgeInsets,
        minimumLineSpacing: CGFloat,
        minimumInteritemSpacing: CGFloat
    ) {
        self.sectionInset = sectionInset
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
    
}
