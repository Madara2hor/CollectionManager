//
//  SectionManager.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

open class SectionManager: NSObject {
    
    /**
        Reference to a containing `UICollectionView`.
     */
    internal(set) public weak var collectionManager: SectionedManager? = nil
    
    /**
        Configuration for  section.
     */
    open var sectionConfig: SectionConfig? {
        return nil
    }
    
    /**
        Number of items in section.
     */
    open var numberOfItems: Int {
        fatalError("numberOfItems must be implemented in a sub-class")
    }
    
    /**
        Size for cells in section.
     */
    open var cellSize: CGSize {
        fatalError("cellSize must be implemented in a sub-class")
    }
    
    /**
        Section header height.
     */
    open var headerHeight: CGFloat {
        return 0
    }
    
    /**
        Override for implementing setup cells logic.
     */
    open func setupCell(
        cellFactory: CellFactory
    ) -> UICollectionViewCell {
        fatalError("setupCell(at:cellFactory:) must be implemented in a sub-class")
    }
    
    /**
        Override for implementing section header.
     */
    open func setupHeader(
        cellFactory: CellFactory
    ) -> UICollectionReusableView? {
        return nil
    }
    
    /**
        Override for implementing on item select logic.
     */
    open func itemDidSelect(index: Int) {
        // no-op
    }
    
    /**
        Override for implementing on section scrolled to the end logic.
        It's work only for last section in collection.
     */
    open func didScrollToEnd() {
        // no-op
    }
    
}
