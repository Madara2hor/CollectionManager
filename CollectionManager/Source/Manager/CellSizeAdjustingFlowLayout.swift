//
//  CellSizeAdjustingFlowLayout.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

/**
    A variant of `UICollectionFlowLayout` that does not allow collection cells to exceed the allowed size.
 */
public final class CellSizeAdjustingFlowLayout: UICollectionViewFlowLayout {
    
    /**
        Cell size not exceeding collection size.
     */
    public override var itemSize: CGSize {
        get {
            return adjustCellSize(super.itemSize)
        }
        set {
            super.itemSize = newValue
        }
    }
    
    /**
        Calculates and returns the size of a cell not exceeding the size of the collection.
     */
    func adjustCellSize(
        _ cellSize: CGSize,
        bySectionInsets: UIEdgeInsets? = nil
    ) -> CGSize {
        guard let collectionView = collectionView else {
            return super.itemSize
        }
        /// The size of the cell is limited depending on the direction of the scroll.
        switch scrollDirection {
        case .vertical:
            /// Width limited.
            let insets = bySectionInsets?.horizontal ?? self.sectionInset.horizontal
            let maxWidth = collectionView.frame.width
                - collectionView.contentInset.horizontal
                - insets
            
            return CGSize(
                width: min(maxWidth, cellSize.width),
                height: cellSize.height
            )
        case .horizontal:
            /// Height limited.
            let inset = bySectionInsets?.vertical ?? self.sectionInset.vertical
            let maxHeight = collectionView.frame.height
                - collectionView.contentInset.vertical
                - inset
            
            return CGSize(
                width: cellSize.width,
                height: min(maxHeight, cellSize.height)
            )
        @unknown default:
            fatalError("Scroll direction not supported: \(scrollDirection).")
        }
    }
    
    /**
        Calculates and returns the size of a cell in depends of separation by rows/columns
     */
    func adjustCellSize(
        _ cellSize: CGSize,
        for section: SectionSeparatable,
        using config: Config
    ) -> CGSize  {
        switch scrollDirection {
        case .vertical:
            guard section.columns > 1 else { return cellSize }
            let excludedWidth = config.minimumInteritemSpacing * CGFloat(section.columns - 1)
            return CGSize(
                width: (cellSize.width - excludedWidth) / CGFloat(section.columns),
                height: cellSize.height
            )
        case .horizontal:
            guard section.rows > 1 else { return cellSize }
            let excludedHeight = config.minimumInteritemSpacing * CGFloat(section.rows - 1)
            return CGSize(
                width: cellSize.width,
                height: (cellSize.height - excludedHeight) / CGFloat(section.rows)
            )
        @unknown default:
            fatalError("Scroll direction not supported: \(scrollDirection).")
        }
    }
    
}
