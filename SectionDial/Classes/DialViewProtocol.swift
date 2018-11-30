//
//  DialViewProtocol.swift
//  SectionDial
//
//  Created by Serhii on 11/16/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol SectionDialViewDelegate: class {
    
    func numberOfElements(in dialView: SectionDialView) -> Int
    func dialView(_ dialView: SectionDialView, elementTitleAtIndex index: Int) -> String
    
    func dialView(_ dialView: SectionDialView, didSelectElementAt index: Int)
}

public protocol SectionDialViewProtocol {
    
    var delegate: SectionDialViewDelegate? { get set }
    var config: SectionDialView.Config { get set }
    var selectedIndex: Int { get }
    
    func setSelectedIndex(_ index: Int, withAnimation: Bool)
    func viewDidLayoutSubviews()
    func reloadData()
    
    init(frame: CGRect, delegate: SectionDialViewDelegate?, config: SectionDialView.Config?)
}
