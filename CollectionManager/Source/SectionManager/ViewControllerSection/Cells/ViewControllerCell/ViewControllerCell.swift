//
//  ViewControllerCell.swift
//  CollectionManager
//
//  Created by 0x01eva on 02.08.2021.
//

import UIKit

open class ViewControllerCell: UICollectionViewCell {
    
    var viewController: UIViewController? {
        didSet {
            oldValue?.view.removeFromSuperview()
            if let view = viewController?.view {
                view.translatesAutoresizingMaskIntoConstraints = false
                addSubview(view)
                view.pinToSuperview()
            }
        }
    }
    
    open override func addSubview(_ view: UIView) {
        if view == viewController?.view {
            super.addSubview(view)
        }
    }
    
}
