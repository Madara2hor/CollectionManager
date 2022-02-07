//
//  TypedSection.swift
//  CollectionManager
//
//  Created by 0x01eva on 28.07.2021.
//

import UIKit

/**
    Sub-class of `TypedSection` will have the same
    scroll direction as `CollectionView` of `CollectionViewManager`.
 */
open class TypedSection<Cell: UICollectionViewCell & CardRepresentable>:
        SectionManager,
        SectionSeparatable,
        SectionLoadable,
        OnLoadingBottomViewPresentable {
    
    // MARK: - Private properties
    
    private var manager: CollectionViewManager? {
        guard let manager = collectionManager as? CollectionViewManager
        else { return nil }
        
        return manager
    }
    
    /// Cell objects of section.
    private var cellObjects: [Cell.CardCellObject] = []
    
    ///Return count of skeletonable items in depends
    ///of current `loadingState`.
    private var skeletonCount: Int {
        switch loadingState {
        case .full:
            return 6
        case .partial:
            guard let scrollDirection = manager?.config.scrollDirection
            else { return 0 }
            return partialSkeletonCount(by: scrollDirection)
        case .none:
            return 0
        }
    }
    
    /// Returns the number of skeletons
    /// depending on the scroll direction.
    private func partialSkeletonCount(
        by scrollDirection: UICollectionView.ScrollDirection
    ) -> Int {
        switch scrollDirection {
        case .vertical:
            let cellsInLastRow = cellObjects.count % columns
            return (columns * 2) - cellsInLastRow
        case .horizontal:
            let cellsInLastColumn = cellObjects.count % rows
            return (rows * 2) - cellsInLastColumn
        @unknown default:
            fatalError("Scroll direction not supported: \(String(describing: scrollDirection)).")
        }
    }
    
    // MARK: - Open properties
    /**
        Override to change skeleton setup.
     */
    open var skeletonSetup: SkeletonSetup {
        return .default
    }
    
    // MARK: - Open Override
    
    /// Setup and return collection view cell.
    open override func setupCell(
        cellFactory: CellFactory
    ) -> UICollectionViewCell {
        let index = cellFactory.indexPath.row
        if shouldDisplayOnLoadingCell(on: index) {
            let onLoadingCell = cellFactory.cell(
                of: OnLoadingBottomViewCell.self,
                reuseId: OnLoadingBottomViewCell.reuseIdentifier
            )
            onLoadingCell.view = onLoadingView
            onLoadingCell.hideSkeleton()
            
            return onLoadingCell
        } else if index >= cellObjects.count {
            let cell = cellFactory.cell(
                of: Cell.self
            )
            cell.showSkeleton(with: skeletonSetup)
            
            return cell
        } else {
            let cell = cellFactory.cell(
                of: Cell.self
            )
            cell.bind(with: cellObjects[index])
            cell.hideSkeleton()
            
            return cell
        }
    }
    
    /// Number of items in collection.
    public override var numberOfItems: Int {
        var itemsCount = cellObjects.count + skeletonCount
        
        if loadingState == .partial {
            itemsCount += (isNeedOnLoadingBottomViewCell ? 1 : 0)
        }
        
        return itemsCount
    }

    // MARK: - Open methods
    /**
        Updating collection view with objects.
     */
    open func update(with cellObjects: [Cell.CardCellObject]?) {
        self.cellObjects = cellObjects ?? []
        loadingState = .none
    }
    
    // MARK: - SectionSeparating
    /**
        Number of rows in horizontal scrolling collection. Default 1.
     */
    open var rows: Int {
        return 1
    }
    
    /**
        Number of columns in vertical scrolling collection. Default 1.
     */
    open var columns: Int {
        return 1
    }
    
    // MARK: - SectionUpdatable
    /**
        Section current loading state.
     */
    private(set) public var loadingState: SectionLoadingState = .none {
        didSet {
            guard loadingState != oldValue else { return }
            switch loadingState {
            case .full:
                cellObjects = []
            case .partial:
                manager?.reloadSection(self)
            case .none:
                collectionManager?.sectionDidLoadData(self)
            }
        }
    }
    
    /**
        Override logic to request data.
        Should call `super`.
     */
    open func loadData() {
        loadingState = .full
    }
    
    /**
        Override logic to request additional data.
        Should call `super`.
     */
    open func uploadData() {
        loadingState = .partial
    }
    
    // MARK: - OnLoadingBottomViewPresenting
    /**
        View container for on loading cell.
     */
    open var onLoadingView: ViewContainer {
        return OnLoadingView()
    }
    
    /**
        Special on loading bottom view.
     */
    open var isNeedOnLoadingBottomViewCell: Bool {
        return false
    }
    
    /**
        On loading bottom view size.
     */
    open var onLoadingBottomViewCellSize: CGSize {
        return .zero
    }
    
    /**
     Determines whether to show on loading view.
     */
    public func shouldDisplayOnLoadingCell(on index: Int) -> Bool {
        return isNeedOnLoadingBottomViewCell
                && loadingState == .partial
                && numberOfItems - 1 == index
    }
    
}
