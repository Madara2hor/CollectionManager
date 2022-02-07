//
//  Manager.swift
//  CollectionManager
//
//  Created by 0x01eva on 04.02.2022.
//

import UIKit

public protocol Manager: AnyObject {
    var delegate: ManagerDelegate?  { get set }
    
    func reloadData(in section: SectionManager?, onlyVisible: Bool)
    func refreshSections()
    func setSection(_ section: SectionManager, hidden: Bool)
    func reloadSection(_ section: SectionManager)
}

extension Manager {
    
    public func reloadData(onlyVisible: Bool) {
        reloadData(in: nil, onlyVisible: onlyVisible)
    }
    
    public func reloadData(in section: SectionManager?) {
        reloadData(in: section, onlyVisible: true)
    }
    
    public func reloadData() {
        reloadData(in: nil, onlyVisible: true)
    }
    
}
