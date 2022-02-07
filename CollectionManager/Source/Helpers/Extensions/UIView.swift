//
//  UIView.swift
//  CollectionManager
//
//  Created by 0x01eva on 28.01.2022.
//

import UIKit

extension UIView {
    
    func pinToSuperview() {
        guard let superview = superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            superview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            superview.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}

