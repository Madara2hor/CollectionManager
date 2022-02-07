//
//  OnLoadingBottomViewPresentable.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

/**
    Displaying an additional cell when loading new objects.
 */
public protocol OnLoadingBottomViewPresentable {
    /**
        View container for on loading cell.
     */
    var onLoadingView: ViewContainer { get }
    
    /**
        Returns a size for a last cell if it must be different.
     */
    var onLoadingBottomViewCellSize: CGSize { get }
    
    /**
        Special on loading bottom view.
     */
    var isNeedOnLoadingBottomViewCell: Bool { get }
    
    /**
     Determines whether to show on loading view depending on conditions.
     */
    func shouldDisplayOnLoadingCell(on index: Int) -> Bool
    
}
