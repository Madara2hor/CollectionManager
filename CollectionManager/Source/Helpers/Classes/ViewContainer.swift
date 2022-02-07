//
//  ViewContainer.swift
//  CollectionManager
//
//  Created by 0x01eva on 28.01.2022.
//

import UIKit

/// An abstract display container.
///
/// Inherit from it and create an XIB file of the same name.
/// The content of the XIB file will be loaded into the `content` property and
/// positioned over the entire available display area.
/// You can also add any outlets or activities to the successor.
open class ViewContainer: UIView {
    
    /**
        The content of the XIB file managed by this container.
     */
    var content: UIView!

    /**
        The name of the .xib file if the descendant uses the .xib of its superclass.
     */
    var nibName: String? { return nil }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        adjustContent()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        adjustContent()
    }

    // Adds content to display.
    private func adjustContent() {
        guard type(of: self) != ViewContainer.self else {
            fatalError("You must inherit from the ViewContainer and create a similar XIB.")
        }

        backgroundColor = .clear

        content = loadContent()
        addSubview(content)
        content.pinToSuperview()
        self.prepareForDisplay()
    }

    // Loads content from an XIB file.
    private func loadContent() -> UIView {
        let nibName = self.nibName ?? String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let content = nib.instantiate(withOwner: self)
        
        guard let result = content.first as? UIView else {
            fatalError("The view obtained from XIB does not match of type \(UIView.self)")
        }

        return result
    }

    // MARK: Life cycle

    func prepareForDisplay() {
        // Override the function to customize.
    }
    
}
