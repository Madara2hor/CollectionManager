//
//  UIEdgeInsets.swift
//  CollectionManager
//
//  Created by 0x01eva on 28.01.2022.
//

import UIKit

extension UIEdgeInsets {
    
    var vertical: CGFloat {
        return self.top + self.bottom
    }
    
    var horizontal: CGFloat {
        return self.left + self.right
    }
    
}
