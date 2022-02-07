//
//  SectionSeparating.swift
//  CollectionManager
//
//  Created by 0x01eva on 21.01.2022.
//

import Foundation

/**
    Separate section by rows/columns.
 */
public protocol SectionSeparatable {
    /**
        Number of rows in horizontal scrolling collection.
     */
    var rows: Int { get }
    
    /**
        Number of columns in vertical scrolling collection.
     */
    var columns: Int { get }
}
