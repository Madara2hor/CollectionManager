//
//  OnLoadingBottomViewCell.swift
//  CollectionManager
//
//  Created by 0x01eva on 28.01.2022.
//

import UIKit

class OnLoadingBottomViewCell: UICollectionViewCell {
    
    var view: ViewContainer? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = self.view {
                addSubview(view)
                view.pinToSuperview()
            }
        }
    }
    
}
