//
//  HorizontalCollectionSection.swift
//  CollectionManager
//
//  Created by user on 20.01.2022.
//

import UIKit

/**
    Sub-class of `CollectionViewSection` can be used as separate class
    or can be implement in `CollectionManager` via `ViewControllerCollectionSection`.
 */
public class CollectionViewSection<Cell: UICollectionViewCell & CardRepresentable>:
    NSObject,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    // MARK: - Private Properties
    
    /// Collection objects.
    private var cellObjects: [Cell.CardCellObject] = []
    
    // MARK: - Public Propertie
    
    /**
        Collection manager collection view.
     */
    public let collectionView: UICollectionView
    
    /**
        Collection flow.
     */
    public let flowLayout: UICollectionViewFlowLayout
    
    /**
        Collection config.
     */
    public let config: CollectionConfig
    
    // MARK: - init
    
    init(
        collectionView: UICollectionView,
        config: CollectionConfig
    ) {
        self.collectionView = collectionView
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("HorizontalCollectionSection only supports collection views with flow layout.")
        }
        self.flowLayout = flowLayout
        self.config = config
        super.init()
        
        
        setupCollectionView(collectionView, with: config)
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    
    /// Setup collection view and collection flow by config.
    private func setupCollectionView(
        _ collectionView: UICollectionView,
        with config: CollectionConfig
    ) {
        collectionView.register(cell: Cell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.isScrollEnabled = config.isScrollEnabled
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        flowLayout.scrollDirection = config.scrollDirection
        flowLayout.minimumLineSpacing = config.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = config.minimumInteritemSpacing
    }
    
    /// Scroll collection view to top.
    private func scrollToTop() {
        if !cellObjects.isEmpty {
            collectionView.setContentOffset(
                CGPoint(
                    x: -collectionView.contentInset.left,
                    y: -collectionView.contentInset.top
                ),
                animated: false
            )
        }
    }
    
    // MARK: - Public methods
    
    /**
        Updating collection view with objects.
     */
    public func update(with cellObjects: [Cell.CardCellObject]?) {
        self.cellObjects = cellObjects ?? []
    }
        
    // MARK: - Public Override
    
    /**
        Size for cells in section.
     */
    var cellSize: CGSize {
        .zero
    }
    
    /**
        Override for implementing on item select logic.
     */
    func itemDidSelect(at: Int) {
        // no-op
    }
    
    /**
        Override for implementing on section scrolled to the end logic.
     */
    func didScrollToEnd() {
        // no-op
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize != .zero else {
            return
        }
        
        let endMargin: CGFloat = 20

        let isAtEnd: Bool
        switch flowLayout.scrollDirection {
        case .vertical:
            isAtEnd = scrollView.contentOffset.y >= (
                scrollView.contentSize.height - scrollView.bounds.height
            ) - endMargin
        case .horizontal:
            isAtEnd = scrollView.contentOffset.x >= (
                scrollView.contentSize.width - scrollView.bounds.width
            ) - endMargin
        @unknown default:
            fatalError("Scroll direction not supported: \(flowLayout.scrollDirection).")
        }
        
        if isAtEnd {
            didScrollToEnd()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        itemDidSelect(at: indexPath.row)
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        cellObjects.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as Cell
        cell.bind(with: cellObjects[indexPath.row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let flow = flowLayout as? CellSizeAdjustingFlowLayout else {
            return cellSize
        }
        
        return flow.adjustCellSize(cellSize)
    }
    
}
