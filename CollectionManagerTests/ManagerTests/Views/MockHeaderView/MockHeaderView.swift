//
//  MockHeaderView.swift
//  CollectionManagerTests
//
//  Created by 0x01eva on 02.02.2022.
//

import UIKit
@testable import CollectionManager

class MockHeaderView: UICollectionReusableView {

    @IBOutlet weak var title: UILabel!
    
    func bind(with title: String) {
        self.title.text = title
    }
    
}
