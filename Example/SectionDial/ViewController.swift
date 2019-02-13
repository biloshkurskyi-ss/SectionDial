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
    
    // MARK: - Outlets
    @IBOutlet weak var dialView: SectionDialView! {
        didSet {
            dialView.config.cellSize = CGSize(width: 100, height: 53)
        }
    }
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: DialTableViewCellExample.identifier, bundle: nil), forCellReuseIdentifier: DialTableViewCellExample.identifier)
        }
    }
    
    // MARK: - Private variablesww
    private var manualDialView: SectionDialView!
    private var elementsCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialView.setSelectedIndex(20, withAnimation: false)

        manualDialView = SectionDialView(frame: CGRect(x: 20, y: 150, width: self.view.bounds.width - 40, height: 60), delegate: self)
        manualDialView.tag = 1001
        self.view.addSubview(manualDialView)
        manualDialView.setSelectedIndex(30, withAnimation: false)
    }
}

// MARK: - SectionDialViewDelegate
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

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DialTableViewCellExample.identifier) as? DialTableViewCellExample else { return UITableViewCell() }
        cell.scrollToRundomIndex()
        return cell
    }
}
