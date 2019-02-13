//
//  DialCollectionViewCellSettings.swift
//  SectionDial
//
//  Created by Sergey Biloshkurskyi on 2/13/19.
//

import Foundation

public struct DialCollectionViewCellSettings {
    public var numberOfMarkers = 5
    public var generalMarkHeight = 6.0
    public var centralMarkHeight = 15.0
    public var markWidth = 2.0
    public var yPosition: MarkYPosition = .bottom
    
    public enum MarkYPosition {
        case top,
        bottom
    }
}
