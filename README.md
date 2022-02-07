# CollectionManager

____
### 📄Description 

CollectionManager - a UICollectionView manager that allows you to easily manage sections. Sections can be: vertical, horizontal and consist of one cell.

![Library example](/Assets/asset_0.gif?rawValue=true "Library example")
____
### 🔨Connecting

1. Add CollectionManager in the pod file.
```
target 'app_name' do
  use_frameworks!
  pod 'CollectionManager' -> 'last.version'
```

3. Next, install the library from the root folder of the project.
```
pod install
```

4. Connect the library in the desired class.
```swift
import CollectionManager
```
----
### HowTo
``` Swift
final class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionManager = CollectionViewManager(
                collectionView: collectionView,
                sections: [
                    section
                ], 
                hiddenSections: [],
                config: .default
            )
        }
    }
    
    var collectionManager: Manager!
    var section: SectionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
```

____
### 🤌🏼Properties

#### Manager
| Property | getter, setter |
|:----|:----|
| collectionView | ✅, ❌ |
| flowLayout | ✅, ❌ |
| config | ✅, ❌ |
| visibleSections | ✅, ❌ |
| delegate| ✅, ✅ | 

#### SectionManager
| Property | getter, setter |
|:----|:----|
| collectionManager | ✅, ❌ |
| sectionConfig | ✅, ✅ |
| numberOfItems | ✅, ❌ |
| cellSize | ✅, ✅ |
| headerHeight | ✅, ✅ |

> SectionManager properties also available in TypedSection and ViewControllerSection.

#### TypedSection
| Property | getter, setter |
|:----|:----|
| skeletonSetup | ✅, ✅ |
| loadingState | ✅, ❌ |
| rows | ✅, ✅ |
| columns | ✅, ✅ |
| onLoadingView | ✅, ✅ |
| isNeedOnLoadingBottomViewCell | ✅, ✅ |
| onLoadingBottomViewCellSize | ✅, ✅ |

#### ViewControllerSection
| Property | getter, setter |
|:----|:----|
| viewController | ✅, ❌ |
| reusableId | ✅, ✅ |
| loadingState | ✅, ❌ |

____
### 🤙🏼Methods

### Manager

#### ReloadData
```Swift
func reloadData(
    in section: SectionManager? = nil,
    onlyVisible: Bool = true
)
```

Example:
```Swift
// Reload data in only visible sections.
collectionManager.reloadData()
// Reload data in all sections.
collectionManager.reloadData(onlyVisible: false)
// Reload data in the section if it is visible.
collectionManager.reloadData(in: section) 
// Will reload data in the section even if it is hidden.
collectionManager.reloadData(in: section, onlyVisible: false) 
```

#### ReloadSection
```Swift
func reloadSection(_ section: SectionManager)
```

Example:
```Swift
// Reload data in the section if it is visible.
collectionManager.reloadSection(section)
```

#### SetSection
```Swift
func setSection(
    _ section: SectionManager,
    hidden: Bool
)
```

Example:
```Swift
// Show/hide section You need.
collectionManager.setSection(section, hidden: true)
```

#### ScrollToTop
```Swift
func scrollToTop()
```

Example:
```Swift
collectionManager.scrollToTop()
```

### SectionManager

#### SectionDidLoadData
```Swift
func sectionDidLoadData(_ section: SectionManager)
```

Example:
```Swift
class Section: SectionManager {
    
    var loadingState: SectionLoadingState = .none {
        didSet {
            guard loadingState != oldValue else { return }
            switch loadingState {
            case .full:
                // You can show the skeleton on a cell there.
                break
            case .partial:
                break
            case .none:
                // You can hide the skeleton from the cell there.
                collectionManager?.sectionDidLoadData(self)
            @unknown default:
                fatalError("Unknown section loading state: \(loadingState)")
            }
        }
    }
    
}

extension Section: SectionLoadable {

    func loadData() {
        loadingState = .full
    }

}
```
> ❗️When using the method, the delegate will work on the completion of the data loading. Therefore, for better work, it is necessary to extend the class with the SectionLoadable protocol.

#### SetupCell
```Swift
func setupCell(
    cellFactory: CellFactory
) -> UICollectionViewCell {
    fatalError("setupCell(at:cellFactory:) must be implemented in a sub-class")
}
```

Example:
```Swift
override func setupCell(
    cellFactory: CellFactory
) -> UICollectionViewCell {
    return cellFactory.cell(of: YourCell.self)
}
```

#### SetupCell
```Swift
func setupHeader(
    cellFactory: CellFactory
) -> UICollectionReusableView? {
    return nil
}
```

Example:
```Swift
override func setupHeader(
    cellFactory: CellFactory
) -> UICollectionReusableView? {
    return cellFactory.header(of: YourHeaderView.self)
}
```

#### ItemDidSelect
```Swift
func itemDidSelect(index: Int)
```

Example:
```Swift
override func itemDidSelect(index: Int) {
    // Do something with Your data.
}
```

#### DidScrollToEnd
```Swift
func didScrollToEnd()
```

Example:
```Swift
override func didScrollToEnd() {
    // You can upload data there, for example.
}
```

> SectionManager methods also available in TypedSection and ViewControllerSection.

### TypedSection

#### UpdateData
```Swift
func update(with cellObjects: [Cell.CardCellObject]?)
```

Example:
```
update(with: ArrayOfItems)
```

#### LoadData
```Swift
func loadData()
```

Example:
```Swift
func loadData() {
    super.loadData()
    // Request data there.
}
```

> This method also available in a ViewControllerSection.

#### UploadData
```Swift
func uploadData()
```

Example:
```Swift
func uploadData() {
    super.uploadData()
    // Request additional data there.
}
```

#### DataLoaded
```Swift
func dataLoaded()
```

Example:
```Swift
func onDataLoaded() {
    dataLoaded()
}
```
____
### Автор

Kirill Kapis, Kkprokk07@gmail.com

____
## License

CollectionManager is available under the MIT license. See the LICENSE file for more info.
