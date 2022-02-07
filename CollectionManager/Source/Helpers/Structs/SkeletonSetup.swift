//
//  SkeletonSetup.swift
//  CollectionManager
//
//  Created by 0x01eva on 04.02.2022.
//

import Foundation

public struct SkeletonSetup {
    var duration: Float
    var direction: LoadingAnimationDirection
    
    public static var `default`: Self {
        SkeletonSetup(
            duration: 1.7,
            direction: .leftTopToRightBottom
        )
    }
    
    public init(
        duration: Float,
        direction: LoadingAnimationDirection
    ) {
        self.duration = duration
        self.direction = direction
    }
}
