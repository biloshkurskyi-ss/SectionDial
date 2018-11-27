//
//  ViewController.swift
//  SectionDial
//
//  Created by sergVn on 11/27/2018.
//  Copyright (c) 2018 sergVn. All rights reserved.
//

import UIKit
import SectionDial

class ViewController: UIViewController {

    @IBOutlet var dialView: SectionDialView!
    var manualDialView: SectionDialView!
    
    private var elementsCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manualDialView = SectionDialView(frame: CGRect(x: 20, y: 150, width: self.view.bounds.width - 40, height: 60), delegate: self)
        manualDialView.tag = 1001
        self.view.addSubview(manualDialView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dialView.viewDidLayoutSubviews()
        manualDialView.viewDidLayoutSubviews()
    }
}

extension ViewController: SectionDialViewDelegate {
    func numberOfElements(in dialView: SectionDialView) -> Int {
        return elementsCount
    }
    
    func dialView(_ dialView: SectionDialView, elementTitleAtIndex index: Int) -> String {
        return "\(index) value"
    }
    
    func dialView(_ dialView: SectionDialView, didSelectElementAt index: Int) {
        print("Element selected: \(index) in DialView with tag: \(dialView.tag)")
    }
}

