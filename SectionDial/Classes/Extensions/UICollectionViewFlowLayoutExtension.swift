//
//  UICollectionViewFlowLayoutExtension.swift
//  SectionDial
//
//  Created by Sergey Biloshkurskyi on 2/13/19.
//

import Foundation

extension UICollectionViewFlowLayout {
    convenience init(cellSize: CGSize, sectionInset: UIEdgeInsets? = nil) {
        self.init()
        
        scrollDirection = .horizontal
        itemSize = cellSize
        minimumLineSpacing = 0
        
        if let inset = sectionInset {
            self.sectionInset = inset
        }
    }
}
