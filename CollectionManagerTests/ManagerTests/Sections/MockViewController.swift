//
//  MockViewController.swift
//  CollectionManagerTests
//
//  Created by 0x01eva on 02.02.2022.
//

import UIKit
@testable import CollectionManager

class MockViewController: UIViewController { }

class MockViewControllerSection: ViewControllerSection<MockViewController> {
    
    override var reusableId: String? {
        return "MockViewControllerSection"
    }
    
    override var cellSize: CGSize {
        guard let manager = collectionManager as? CollectionViewManager
        else { return .zero }
        let scrollDirection = manager.config.scrollDirection
        switch scrollDirection {
        case .vertical:
            return CGSize(width: .infinity, height: 300.0)
        case .horizontal:
            return CGSize(width: 300.0, height: .infinity)
        @unknown default:
            fatalError("Scroll direction not supported: \(scrollDirection).")
        }
    }
    
    override var sectionConfig: SectionConfig? {
        return SectionConfig(
            sectionInset: UIEdgeInsets(
                top: 16,
                left: 0,
                bottom: 16,
                right: 0
            ),
            minimumLineSpacing: 0,
            minimumInteritemSpacing: 0
        )
    }
    
}
