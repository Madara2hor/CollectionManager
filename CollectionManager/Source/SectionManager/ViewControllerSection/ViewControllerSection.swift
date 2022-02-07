//
//  ViewControllerSection.swift
//  CollectionManager
//
//  Created by 0x01eva on 20.01.2022.
//

import UIKit

/**
    Sub-class of `ViewControllerSection`
    will contain `ViewController` with it's own logic.
 */
open class ViewControllerSection<VC: UIViewController>:
    SectionManager,
    SectionLoadable {
    
    // MARK: - Public Properties
    /**
        Section `ViewController`.
     */
    public let viewController: VC
    
    // MARK: init
    
    public init(viewController: VC) {
        self.viewController = viewController
        self.viewController.loadViewIfNeeded()
    }
    
    // MARK: - Open Override Properties
    /**
        Collection view cell reusable ID.
     */
    open var reusableId: String? {
        fatalError("reusableId must be implemented in a sub-class")
    }

    /**
        Number of items in section.
     */
    open override var numberOfItems: Int {
        return 1
    }
    
    // MARK: - Open Override Methods
    
    /// Setup section cells.
    open override func setupCell(
        cellFactory: CellFactory
    ) -> UICollectionViewCell {
        let cell = cellFactory.cell(
            of: ViewControllerCell.self,
            reuseId: reusableId
        )
        cell.viewController = viewController
        return cell
    }
    
    // MARK: - SectionUpdatable
    /**
        Section current loading state.
     */
    private(set) public var loadingState: SectionLoadingState = .none {
        didSet {
            guard loadingState != oldValue else { return }
            switch loadingState {
            case .full, .partial:
                break
            case .none:
                collectionManager?.sectionDidLoadData(self)
            }
        }
    }
    
    /**
        Override logic to request data.
        Should call super.
     */
    open func loadData() {
        loadingState = .full
    }
    
    /**
        Call this method when `ViewControllerSection`
        finish loading data.
     */
    public func dataLoaded() {
        loadingState = .none
    }
    
}

