//
//  ReusableTests.swift
//  CollectionManagerTests
//
//  Created by 0x01eva on 04.02.2022.
//

import XCTest
@testable import CollectionManager

class ReusableTests: XCTestCase {
 
    var cell: MockCell!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cell = MockCell.fromNib()
        
    }
    
    override func tearDownWithError() throws {
        cell = nil
        try super.tearDownWithError()
    }
    
    func test_reusable_fromNib() throws {
        cell.bind(with: MockCellObject(title: "Test"))
        
        XCTAssert(cell.label.text == "Test", "Cell awaked from Nib.")
    }
}
