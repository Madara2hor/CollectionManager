//
//  CellFactory.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

public struct CellFactory {
    
    let collectionView: UICollectionView
    let indexPath: IndexPath
    
    public func cell<T: UICollectionViewCell>(
        of type: T.Type,
        reuseId: String? = nil
    ) -> T {
        if let reuseId = reuseId {
            collectionView.register(type, forCellWithReuseIdentifier: reuseId)
        } else {
            collectionView.register(cell: type)
        }
        
        return collectionView.dequeueCell(
            for: indexPath,
               of: type,
               reuseIdentifier: reuseId ?? type.reuseIdentifier
        )
    }
    
    public func supplementaryView<T: UICollectionReusableView>(
        ofKind kind: UICollectionView.UICollectionViewElementKind,
        type: T.Type
    ) -> T {
        collectionView.register(cell: type, forSupplementaryViewOfKind: kind)
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind.rawValue,
            for: indexPath
        ) as T
    }
    
    public func header<T: UICollectionReusableView>(
        of type: T.Type
    ) -> T {
        return supplementaryView(
            ofKind: UICollectionView.UICollectionViewElementKind.header,
            type: type
        )
    }
    
}
