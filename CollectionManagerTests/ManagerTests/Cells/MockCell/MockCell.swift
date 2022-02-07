//
//  MockCell.swift
//  CollectionManagerTests
//
//  Created by 0x01eva on 02.02.2022.
//

import UIKit
@testable import CollectionManager

struct MockCellObject {
    let title: String
}

class MockCell: UICollectionViewCell, CardRepresentable {
    
    @IBOutlet weak var label: UILabel!
    
    func bind(with object: MockCellObject) {
        label.text = object.title
    }

}



