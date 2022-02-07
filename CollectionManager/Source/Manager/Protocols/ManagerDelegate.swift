//
//  ManagerDelegate.swift
//  CollectionManager
//
//  Created by 0x01eva on 01.02.2022.
//

import UIKit

/**
    Delegate for detect when section/sections did load data.
 */
public protocol ManagerDelegate: AnyObject {
    /**
        Section did load data.
     */
    func sectionDidLoadData(_ section: SectionManager)
    /**
        Each section did load data.
     */
    func sectionsDidLoadData()
}
