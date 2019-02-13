//
//  SectionDialViewSettings.swift
//  SectionDial
//
//  Created by Sergey Biloshkurskyi on 2/13/19.
//

import Foundation

public struct SectionDialViewSettings {
    public var cellSize = CGSize(width: 120, height: 60)
    public var centerMarkSize = CGSize(width: 2, height: 20)
    public var cellConfiguration: DialCollectionViewCellSettings? = nil
    
    public init(cellSize: CGSize = CGSize(width: 120, height: 60),
                centerMarkSize: CGSize = CGSize(width: 2, height: 20),
                cellConfiguration: DialCollectionViewCellSettings? = nil) {
        self.cellSize = cellSize
        self.centerMarkSize = centerMarkSize
        self.cellConfiguration = cellConfiguration
    }
}
