//
//  CardRepresentable.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import Foundation

/**
    Card-object protocol.
 */
public protocol CardRepresentable: Reusable {
    /**
        Cell data model.
     */
    associatedtype CardCellObject
    
    /**
        Cell binding with `CardCellObject`.
     */
    func bind(with object: CardCellObject)
}
