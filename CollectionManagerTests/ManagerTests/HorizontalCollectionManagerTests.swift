//
//  HorizontalCollectionManagerTests.swift
//  CollectionManagerTests
//
//  Created by 0x01eva on 03.02.2022.
//

import XCTest
@testable import CollectionManager

class HorizontalCollectionManagerTests: XCTestCase {

    var typedSection: TypedSection<MockCell>!
    var vcSection: ViewControllerSection<MockViewController>!
    var horizontalCollectionView: UICollectionView!
    var collectionManager: Manager!
    
    var loadableSections: [SectionLoadable] {
        guard let manager = collectionManager as? CollectionViewManager else { return [] }
        return manager.visibleSections
            .compactMap { return $0 as? SectionLoadable }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        typedSection = MockTypedSection()
        typedSection.update(with: nil)
        vcSection = MockViewControllerSection(
            viewController: MockViewController()
        )
        horizontalCollectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 300, height: 1000),
            collectionViewLayout: CellSizeAdjustingFlowLayout()
        )
        collectionManager = CollectionViewManager(
            collectionView: horizontalCollectionView,
            sections: [
                typedSection,
                vcSection
            ],
            hiddenSections: [],
            config: CollectionConfig(
                sectionInset: UIEdgeInsets(
                    top: 16,
                    left: 16,
                    bottom: 16,
                    right: 16
                ),
                minimumLineSpacing: 12,
                minimumInteritemSpacing: 12,
                scrollDirection: .horizontal,
                isScrollEnabled: true
            )
        )
    }

    override func tearDownWithError() throws {
        typedSection = nil
        vcSection = nil
        horizontalCollectionView = nil
        collectionManager = nil
        try super.tearDownWithError()
    }
    
    func test_reloadDataIn_visibleSections() throws {
        collectionManager.reloadData()
       
        XCTAssert(
            loadableSections
                .allSatisfy { $0.loadingState == .full },
            "Sections is reloading."
        )
    }
    
    func test_reloadDataIn_allSections() throws {
        collectionManager.setSection(typedSection, hidden: true)
        collectionManager.reloadData(onlyVisible: false)
       
        XCTAssert(
            loadableSections
                .allSatisfy { $0.loadingState == .full },
            "Sections is reloading."
        )
    }

    func test_reloadDataIn_alreadyLoadingSections() throws {
        typedSection.loadData()
        collectionManager.reloadData()

        var isDataLoaded: Bool {
            return loadableSections
                .allSatisfy { $0.loadingState == .none }
        }

        XCTAssert(isDataLoaded == false, "Sections already loading.")
    }

}

