//
//  DialTableViewCellExample.swift
//  SectionDial_Example
//
//  Created by Sergey Biloshkurskyi on 2/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SectionDial

class DialTableViewCellExample: UITableViewCell {

    static let identifier = String(describing: DialTableViewCellExample.self)
    
    private var sectionDialView: SectionDialView!
    private var elementsCount = 200
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let settings = SectionDialViewSettings(cellSize: CGSize(width: 100, height: 44))
        sectionDialView =  SectionDialView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44),
                                           delegate: self,
                                           config: settings)
        self.addSubview(sectionDialView)
    }
    
    func scrollToRundomIndex() {
        sectionDialView.setSelectedIndex((0...elementsCount - 1).randomElement()!, withAnimation: false)
    }
}

extension DialTableViewCellExample: SectionDialViewDelegate {
    func numberOfElements(in dialView: SectionDialView) -> Int {
        return elementsCount
    }
    
    func dialView(_ dialView: SectionDialView, elementTitleAtIndex index: Int) -> String {
        return "\(index) value"
    }
    
    func dialView(_ dialView: SectionDialView, didSelectElementAt index: Int) {
        print("Table element selected: \(index)")
    }
}

