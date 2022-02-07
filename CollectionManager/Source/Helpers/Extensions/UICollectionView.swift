//
//  extensions.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

public extension UICollectionView {
    
    /**
        Enumeration of additional cell types for greater type safety.
     */
    enum UICollectionViewElementKind: String, RawRepresentable {
        /**
            Section header.
         */
        case header
        /**
            Section footer.
         */
        case footer

        public var rawValue: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    /**
        Register `UICollectionView` cell.
     */
    func register<T: Reusable>(cell: T.Type) {
        guard let classedCell = cell as? AnyClass else {
            preconditionFailure("Failure to cast \(cell) as AnyClass.")
        }
        let bundle = Bundle(for: classedCell)
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    /**
        Register SupplementaryView for `UICollectionView`.
     */
    func register<T: Reusable>(
        cell: T.Type,
        forSupplementaryViewOfKind elementKind: UICollectionViewElementKind
    ) {
        guard let classedCell = cell as? AnyClass else {
            preconditionFailure("Failure to cast \(cell) as AnyClass.")
        }
        let bundle = Bundle(for: classedCell)
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: bundle)
        register(
            nib,
            forSupplementaryViewOfKind: elementKind.rawValue,
            withReuseIdentifier: cell.reuseIdentifier
        )
    }
    
    /**
        Returns cell at `IndexPath`.
        Convenient use:
            let cell = dequeueCell(for: indexPath) as SomeCell
     */
    func dequeueCell<T: Reusable>(for indexPath: IndexPath, of type: T.Type = T.self, reuseIdentifier: String? = nil) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? type.reuseIdentifier, for: indexPath)
        
        guard let typedCell = cell as? T else {
            preconditionFailure("Failed to get Cell with type: \(type)")
        }
        return typedCell
    }
    
    /**
        Returns a SupplementaryView of the specified type at `IndexPath`.
        Convenient use:
            let cell = dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as SomeSupplementaryView
     */
    func dequeueReusableSupplementaryView<T: Reusable>(
        ofKind elementKind: String,
        for indexPath: IndexPath,
        of type: T.Type = T.self
    ) -> T {
        let cell = dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: type.reuseIdentifier,
            for: indexPath
        )
        guard let typedCell = cell as? T else {
            preconditionFailure("Failed to get SupplementaryView with type: \(type)")
        }
        return typedCell
    }
    
}


