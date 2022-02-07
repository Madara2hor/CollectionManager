//
//  CollectionViewManager.swift
//  CollectionManager
//
//  Created by 0x01eva on 28.07.2021.
//

import UIKit

public protocol SectionedManager: AnyObject {
    func sectionDidLoadData(_ section: SectionManager)
}

public class CollectionViewManager:
    NSObject,
    SectionedManager {
    
    // MARK: - Public properties
    
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
    /**
        Visible collection sections.
     */
    public var visibleSections: [SectionManager] {
        return sections.filter {
            !hiddenSections.contains($0)
        }
    }
    /**
        Delegate for detect when section/sections did load data.
     */
    public weak var delegate: ManagerDelegate?
    
    // MARK: - Private properties
    
    /// Collection sections
    private var sections: [SectionManager] = []
    /// Hidden collection sections
    private var hiddenSections: Set<SectionManager> = []
    /// Contains visible sections that have been scrolled.
    private var scrolledSections: Set<Int> = []
    /// Detect when data in each `SectionLoadable` section is loaded
    private var isDataLoaded: Bool {
        let loadableSections: [SectionLoadable] = visibleSections
            .compactMap { return $0 as? SectionLoadable }
        return loadableSections
            .allSatisfy { $0.loadingState == .none }
    }

    // MARK: - init
    
    public init(
        collectionView: UICollectionView,
        sections: [SectionManager],
        hiddenSections: [SectionManager],
        config: CollectionConfig
    ) {
        self.collectionView = collectionView
        self.sections = sections
        self.hiddenSections = Set(hiddenSections)
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("CollectionManager only supports collection views with flow layout")
        }
        self.flowLayout = flowLayout
        self.config = config
        
        super.init()
        
        
        self.sections.forEach {
            $0.collectionManager = self
        }
        
        setupCollectionView(collectionView, with: config)
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    
    /// Setup collection view and collection flow by config.
    private func setupCollectionView(
        _ collectionView: UICollectionView,
        with config: CollectionConfig
    ) {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.isScrollEnabled = config.isScrollEnabled
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        flowLayout.minimumLineSpacing = config.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = config.minimumInteritemSpacing
        flowLayout.scrollDirection = config.scrollDirection
        flowLayout.sectionInset = config.sectionInset
    }
    
    /// Return visible section by index.
    private func visibleSection(at index: Int) -> SectionManager? {
        if index >= visibleSections.count {
            return nil
        }

        return visibleSections[index]
    }
    
    /// Return array of sections including section from parameter.
    private func visibleSections(
        butAlsoIncluding section: SectionManager
    ) -> [SectionManager] {
        return sections.filter {
            !hiddenSections.contains($0) || $0 == section
        }
    }
    
    // MARK: - Public Methods
    
    /**
        `SectionLoadable` section call this method when data did load.
     */
    public func sectionDidLoadData(_ section: SectionManager) {
        guard let loadableSection = section as? SectionLoadable,
              loadableSection.loadingState == .none else { return }
        delegate?.sectionDidLoadData(section)
        guard isDataLoaded else { return }
        delegate?.sectionsDidLoadData()
    }

    /**
        Scroll collection view to the top.
     */
    public func scrollToTop() {
        collectionView.setContentOffset(
            CGPoint(
                x: -collectionView.contentInset.left,
                y: -collectionView.contentInset.top
            ),
            animated: false
        )
    }
    
    // MARK: - UIScrollViewDelegate
    
    /// It's need for detecting scroll from top to bottom
    private var lastScrollOffset: CGFloat? = nil
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize != .zero else {
            return
        }
        
        switch flowLayout.scrollDirection {
        case .vertical:
            guard scrollView.contentOffset.y > .zero else { return }
            
            if let lastOffset = lastScrollOffset,
             lastOffset < scrollView.contentOffset.y {
                sectionScrolledIfNeeded()
            }
            lastScrollOffset = scrollView.contentOffset.y
        case .horizontal:
            guard scrollView.contentOffset.x > .zero else { return }
            
            if let lastOffset = lastScrollOffset,
             lastOffset < scrollView.contentOffset.x {
                sectionScrolledIfNeeded()
            }
            lastScrollOffset = scrollView.contentOffset.x
        @unknown default:
            fatalError("Scroll direction not supported: \(flowLayout.scrollDirection).")
        }
    }
    
    /// Call `didScrollToEnd` for section that last element is visible.
    private func sectionScrolledIfNeeded() {
        var visibleSections: Set<Int> = []
        
        collectionView.indexPathsForVisibleItems.forEach {
            visibleSections.insert($0.section)
        }
        
        scrolledSections = scrolledSections.intersection(visibleSections)
        for section in visibleSections {
            if let visibleSection = visibleSection(at: section) {
                let lastItemIndexPath = IndexPath(
                    row: visibleSection.numberOfItems - 1,
                    section: section
                )
                let isContainsIndexPath = collectionView
                    .indexPathsForVisibleItems
                    .contains(lastItemIndexPath)
                if isContainsIndexPath,
                   !scrolledSections.contains(section) {
                    scrolledSections.insert(section)
                    guard let updatableSection = visibleSection as? SectionLoadable else {
                        visibleSection.didScrollToEnd()
                        return
                    }

                    if updatableSection.loadingState == .none {
                        visibleSection.didScrollToEnd()
                    }
                } else if !isContainsIndexPath {
                    scrolledSections.remove(section)
                }
            }
        }
    }
    
}

// MARK: - Manager
extension CollectionViewManager: Manager {
    /**
        Reload data in a specific or all sections of the manager.
     */
    public func reloadData(
        in section: SectionManager? = nil,
        onlyVisible: Bool = true
    ) {
        guard isDataLoaded else { return }
        
        let loadVisible: ((SectionManager) -> Void) = { section in
            if let loadableSection = section as? SectionLoadable {
                loadableSection.loadData()
            }
        }
        let loadInvisible: ((SectionManager) -> Void) = { section in
            if let loadableSection = section as? SectionLoadable {
                self.setSection(section, hidden: false)
                loadableSection.loadData()
                self.reloadSection(section)
            }
        }
        
        if onlyVisible {
            if let section = section,
               !hiddenSections.contains(section) {
               loadVisible(section)
            } else {
                visibleSections.forEach { section in
                    loadVisible(section)
                }
            }
        } else {
            if let section = section {
                loadInvisible(section)
            } else {
                sections.forEach { section in
                    loadInvisible(section)
                }
            }
        }
        
        collectionView.reloadData()
    }
    
    /**
        Visible section reloading.
     */
    public func reloadSection(_ section: SectionManager) {
        guard let index = visibleSections.firstIndex(of: section) else {
            return
        }
        
        UIView.performWithoutAnimation {
            collectionView.reloadSections([index])
        }
    }
    
    /**
        Refresh all sections. It's make them visible.
     */
    public func refreshSections() {
        sections.forEach {
            setSection($0, hidden: false)
        }
        collectionView.reloadData()
    }
    
    /**
        Changing section visibility.
     */
    public func setSection(
        _ section: SectionManager,
        hidden: Bool
    ) {
        let isAlreadyHidden = hiddenSections.contains(section)
        
        /// In tests this method doesn't work if I don't call
        /// `collectionView.numberOfSections`.
        /// So I decide to add this here for avoid errors.
        let _ = collectionView.numberOfSections
        
        if hidden && !isAlreadyHidden {
            guard let index = visibleSections
                    .firstIndex(of: section) else { return }
            
            hiddenSections.insert(section)
            
            UIView.performWithoutAnimation {
                collectionView.deleteSections([index])
            }
        } else if !hidden && isAlreadyHidden {
            guard let index = visibleSections(butAlsoIncluding: section)
                    .firstIndex(of: section) else { return }
            
            hiddenSections.remove(section)
            
            UIView.performWithoutAnimation {
                collectionView.insertSections([index])
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewManager: UICollectionViewDataSource {
    
    public func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return sections.count - hiddenSections.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return visibleSection(at: section)?.numberOfItems ?? 0
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch flowLayout.scrollDirection {
        case .vertical:
            return visibleSection(at: indexPath.section)?.setupHeader(
                cellFactory: CellFactory(
                    collectionView: collectionView,
                    indexPath: indexPath
                )
            ) ?? UICollectionReusableView()
        case .horizontal:
            return UICollectionReusableView()
        @unknown default:
            fatalError("Scroll direction not supported: \(flowLayout.scrollDirection).")
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let section = visibleSection(at: indexPath.section),
              let cell = collectionView.cellForItem(at: indexPath),
              !cell.isSkeletonActive else { return }
        
        section.itemDidSelect(index: indexPath.row)
    }
    
}

// MARK: - UICollectionViewDelegate
extension CollectionViewManager: UICollectionViewDelegate {
     
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = visibleSection(at: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        return section.setupCell(
            cellFactory: CellFactory(
                collectionView: collectionView,
                indexPath: indexPath
            )
        )
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        switch flowLayout.scrollDirection {
        case .vertical:
            return CGSize(
                width: collectionView.frame.width,
                height: visibleSection(at: section)?.headerHeight ?? 0
            )
        case .horizontal:
            return .zero
        @unknown default:
            fatalError("Scroll direction not supported: \(flowLayout.scrollDirection).")
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let section = visibleSection(at: indexPath.section) else {
            return .zero
        }
        guard let flow = flowLayout as? CellSizeAdjustingFlowLayout else {
            return section.cellSize
        }
        
        /// Checking on `OnLoadingBottomView` is enabled and  needed
        if let sectionWithOnLoadingView = section as? OnLoadingBottomViewPresentable,
           sectionWithOnLoadingView.shouldDisplayOnLoadingCell(on: indexPath.row) {
            return flow.adjustCellSize(
                sectionWithOnLoadingView.onLoadingBottomViewCellSize,
                bySectionInsets: section.sectionConfig?.sectionInset
            )
        }
        
        let cellSize = flow.adjustCellSize(
            section.cellSize,
            bySectionInsets: section.sectionConfig?.sectionInset
        )
        
        if let separatedSection = section as? SectionSeparatable {
            return flow.adjustCellSize(
                cellSize,
                for: separatedSection,
                using: section.sectionConfig ?? config
            )
        }
        
        return cellSize
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return visibleSection(at: section)?.sectionConfig?.minimumLineSpacing ??
            config.minimumLineSpacing
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return visibleSection(at: section)?.sectionConfig?.minimumInteritemSpacing ??
            config.minimumInteritemSpacing
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return visibleSection(at: section)?.sectionConfig?.sectionInset ??
            config.sectionInset
    }
    
}


