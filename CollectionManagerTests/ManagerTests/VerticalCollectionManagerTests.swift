//
//  VerticalCollectionManagerTests.swift
//  CollectionManagerTests
//
//  Created by 0x01eva on 02.02.2022.
//

import XCTest
@testable import CollectionManager

class VerticalCollectionManagerTests: XCTestCase {

    var typedSection: TypedSection<MockCell>!
    var collectionView: UICollectionView!
    var collectionManager: Manager!
    
    var loadableSections: [SectionLoadable] {
        guard let manager = collectionManager as? CollectionViewManager else { return [] }
        return manager.visibleSections
            .compactMap { return $0 as? SectionLoadable }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        typedSection = MockTypedSection()
        typedSection.update(with: [
            MockCellObject(title: "mock"),
            MockCellObject(title: "mock"),
            MockCellObject(title: "mock"),
            MockCellObject(title: "mock"),
        ])
        collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 300, height: 1000),
            collectionViewLayout: CellSizeAdjustingFlowLayout()
        )
        collectionManager = CollectionViewManager(
            collectionView: collectionView,
            sections: [
                typedSection
            ],
            hiddenSections: [],
            config: .default
        )
        collectionManager.delegate = self
    }

    override func tearDownWithError() throws {
        typedSection = nil
        collectionView = nil
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

    func test_reloadDataIn_Section() throws {
        collectionManager.reloadData(in: typedSection)
        
        XCTAssert(typedSection.loadingState == .full, "TypedSection is reloading.")
    }
    
    func test_reloadDataIn_hiddenSection() throws {
        collectionManager.setSection(typedSection, hidden: true)
        collectionManager.reloadData(in: typedSection)
        
        XCTAssert(
            typedSection.loadingState == .none,
            "TypedSection is hidden and cannot be reloaded."
        )
    }
    
    func test_reloadDataIn_hiddenSection_withShowing() throws {
        collectionManager.setSection(typedSection, hidden: true)
        collectionManager.reloadData(in: typedSection, onlyVisible: false)

        XCTAssert(
            typedSection.loadingState == .full,
            "TypedSection now is visible and reloading."
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
    
    func test_refreshSections() throws {
        guard let manager = collectionManager as? CollectionViewManager else { return }
        manager.visibleSections.forEach {
            collectionManager.setSection($0, hidden: true)
        }
        collectionManager.refreshSections()

        XCTAssert(
            manager.visibleSections.count == 1,
            "Sections refreshed and visible now."
        )
    }
    
    // section
    func test_skeletonableOnPartial() throws {
        typedSection.uploadData()
        guard let manager = collectionManager as? CollectionViewManager,
            let sectionIndex = manager.visibleSections.firstIndex(of: typedSection)
        else { return }
        
        
        /// `numberOfItems - 2` because section have onLoadingButtomView.
        let cellIndexPath = IndexPath(
            row: typedSection.numberOfItems - 2,
            section: sectionIndex
        )
        guard let cell = collectionView
            .cellForItem(at: cellIndexPath) else { return }
        XCTAssert(
            cell.isSkeletonActive == true,
            "Last cell is skeletonable."
        )
    }
    // section
    func test_skeletonableOnFull() throws {
        typedSection.loadData()
        guard let manager = collectionManager as? CollectionViewManager,
            let sectionIndex = manager.visibleSections.firstIndex(of: typedSection)
        else { return }
        
        var indexPaths = [IndexPath]()
        for index in 0..<typedSection.numberOfItems {
            indexPaths.append(IndexPath(row: index, section: sectionIndex))
        }
        var cells = [UICollectionViewCell]()
        indexPaths.forEach {
            guard let cell = collectionView.cellForItem(at: $0) else { return }
            cells.append(cell)
        }
        
        XCTAssert(
            cells.allSatisfy({ $0.isSkeletonActive == true }),
            "All sections is skeletonable."
        )
    }
    
    func test_sectionDidLoadData() throws {
        collectionManager.setSection(typedSection, hidden: true)
        
        guard let manager = collectionManager as? CollectionViewManager else { return }
        manager.sectionDidLoadData(typedSection)
        
        XCTAssert(
            manager.visibleSections.contains(typedSection),
            "TypedSection did reload data."
        )
    }

}

extension VerticalCollectionManagerTests: ManagerDelegate {
    
    func sectionDidLoadData(_ section: SectionManager) {
        collectionManager.setSection(section, hidden: false)
    }
    
    func sectionsDidLoadData() {
        // no-op
    }
    
}
