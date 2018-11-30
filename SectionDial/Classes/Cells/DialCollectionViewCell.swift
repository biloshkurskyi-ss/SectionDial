//
//  DialCollectionViewCell.swift
//  SectionDial
//
//  Created by Serhii on 11/16/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

public class DialCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    static let identifier = String(describing: DialCollectionViewCell.self)
    
    // MARK: - Instance Properties
    open var config = Config()
    
    // MARK: - Outlets
    @IBOutlet var label: UILabel!
    
    // MARK: - View Lifecycle
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let indentBetweenMarkers = (bounds.size.width.double - config.numberOfMarkers.double * config.markWidth) / config.numberOfMarkers.double
        (0..<config.numberOfMarkers).forEach { markIndex in
            let height = (config.numberOfMarkers / 2) == markIndex ?  config.centralMarkHeight : config.generalMarkHeight
            let markPositionX = indentBetweenMarkers / 2 + markIndex.double * indentBetweenMarkers + markIndex.double * config.markWidth
            let markPositionY = config.yPosition == .top ? 0 : bounds.size.height.double - label.frame.height.double - height
            let markRect = CGRect(x: Double(markPositionX), y: markPositionY, width: config.markWidth, height: height)
            let markPath = UIBezierPath(roundedRect: markRect, cornerRadius: 0.0)
            
            ctx.addPath(markPath.cgPath)
        }
        
        ctx.fillPath()
    }
    
    // MARK: - Instance Methods
    func setupTitle(_ title: String) {
        label.text = title
    }
}

extension DialCollectionViewCell {
    public struct Config {
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
}

extension Int {
    fileprivate var double: Double {
        return Double(self)
    }
}

extension CGFloat {
    fileprivate var double: Double {
        return Double(self)
    }
}
