//
//  Config.swift
//  CollectionManager
//
//  Created by 0x01eva on 25.01.2022.
//

import UIKit

protocol Config {
    var sectionInset: UIEdgeInsets { get }
    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
}
