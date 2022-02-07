//
//  SectionLoadingState.swift
//  CollectionManager
//
//  Created by 0x01eva on 24.01.2022.
//

import Foundation

/**
    Section loading state.
 */
public enum SectionLoadingState {
    /**
        Section is cleared their data and fetch new.
     */
    case full
    /**
        Section is loading new data.
     */
    case partial
    /**
        No data loading.
     */
    case none
}
