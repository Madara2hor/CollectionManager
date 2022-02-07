//
//  MockTypedSection.swift
//  CollectionManagerTests
//
//  Created by 0x01eva on 02.02.2022.
//

import UIKit
@testable import CollectionManager

class MockTypedSection: TypedSection<MockCell> {
    
    override var headerHeight: CGFloat {
        return 50.0
    }

    override func setupHeader(
        cellFactory: CellFactory
    ) -> UICollectionReusableView? {
        let header = cellFactory.header(of: MockHeaderView.self)
        header.bind(with: "Section")
        return header
    }
    
    override var cellSize: CGSize {
        guard let manager = collectionManager as? CollectionViewManager
        else { return .zero }
        let scrollDirection = manager.config.scrollDirection
        switch scrollDirection {
        case .vertical:
            return CGSize(width: .infinity, height: 150.0)
        case .horizontal:
            return CGSize(width: 150.0, height: .infinity)
        @unknown default:
            fatalError("Scroll direction not supported: \(scrollDirection).")
        }
    }
    
    override var columns: Int {
        return 2
    }
    
    override var rows: Int {
        return 2
    }
    
    override var isNeedOnLoadingBottomViewCell: Bool {
        return true
    }
    
    override var onLoadingView: ViewContainer {
        return MockOnLoadingView()
    }
    
    override var onLoadingBottomViewCellSize: CGSize {
        return CGSize(width: 50.0, height: 80.0)
    }
    
    override func didScrollToEnd() {
        uploadData()
    }
    
}
