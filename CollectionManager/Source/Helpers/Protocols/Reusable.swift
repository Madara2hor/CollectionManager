//
//  Reusable.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

/**
    Reusable object protocol.
 */
public protocol Reusable {
    /**
        Reuse ID.
     */
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    static func fromNib() -> Self {
        guard let classedSelf = Self.self as? AnyClass else {
            preconditionFailure("Failure to cast \(Self.self) as AnyClass.")
        }
        let bundle = Bundle(for: classedSelf)
        let nib = UINib(nibName: self.reuseIdentifier, bundle: bundle)
        let content = nib.instantiate(withOwner: nil)
        
        guard let typedSelf = content.first as? Self else {
            preconditionFailure("Failed to to get \(Self.self)")
        }
        return typedSelf
    }
    
}

extension UICollectionReusableView: Reusable {}
extension UITableViewCell: Reusable {}
