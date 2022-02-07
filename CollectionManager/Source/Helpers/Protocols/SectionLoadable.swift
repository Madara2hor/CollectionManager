//
//  SectionLoadable.swift
//  CollectionManager
//
//  Created by 0x01eva on 24.01.2022.
//

import Foundation

/**
    Changes the loading state of a section.
 */
public protocol SectionLoadable {
    
    /**
        Section loading state.
     */
    var loadingState: SectionLoadingState { get }
    
    /**
        Override for implement request data logic.
     */
    func loadData()
    
}

