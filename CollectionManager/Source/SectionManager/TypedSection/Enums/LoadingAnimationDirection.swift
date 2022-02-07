//
//  LoadingAnimationDirection.swift
//  CollectionManager
//
//  Created by 0x01eva on 28.01.2022.
//

import Foundation

/**
    Load animation direction.
 */
public enum LoadingAnimationDirection: Int {
    // vertical.
    case topToBottom = 0
    case bottomToTop
    // horizontal.
    case leftToRight
    case rightToLeft
    // diagonal.
    case leftTopToRightBottom
    case leftBottomToRightTop
    case rightTopToLeftBottom
    case rightBottomToLeftTop
}
