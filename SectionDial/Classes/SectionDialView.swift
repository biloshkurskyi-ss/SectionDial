//
//  DialView.swift
//  SectionDial
//
//  Created by Serhii on 11/16/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import Foundation
import UIKit

public class SectionDialView: UIView, SectionDialViewProtocol {

    // MARK: - DialViewProtocol
    @IBOutlet weak public var delegate: SectionDialViewDelegate?
    public var selectedIndex: Int = 0 {
        didSet {
            delegate?.dialView(self, didSelectElementAt: selectedIndex)
        }
    }
    
    public func setSelectedIndex(_ index: Int, withAnimation animated: Bool) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0) , at: .centeredHorizontally, animated: animated)
    }
    
    public func viewDidLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Constructors
    required convenience public init(frame: CGRect, delegate: SectionDialViewDelegate?, cellSize: CGSize? = nil, markSize: CGSize? = nil, cellConfiguration: DialCollectionViewCell.Config? = nil) {
        self.init(frame: frame)

        if let cellSize = cellSize {
            self.cellSize = cellSize
        }
        if let delegate = delegate {
            self.delegate = delegate
        }
        if let markSize = markSize {
            self.centerMarkSize = markSize
        }
        if let configuration = cellConfiguration {
            self.cellConfiguration = configuration
        }
        
        initCollectionView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .clear
        
        initCollectionView()
    }

    // MARK: - Private Variables
    private var cellSize = CGSize(width: 120, height: 60)
    private var centerMarkSize = CGSize(width: 2, height: 20)
    private var cellConfiguration: DialCollectionViewCell.Config?
    
    // MARK: - Outlets
    private var collectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.clear(rect)

        let markRect = CGRect(x: (bounds.size.width / 2) - (centerMarkSize.width / 2),
                              y: 0,
                              width: centerMarkSize.width,
                              height: centerMarkSize.height)
        let path = UIBezierPath(roundedRect: markRect,
                                cornerRadius: 1.0)
        
        ctx.addPath(path.cgPath)
        ctx.fillPath()
    }
    
    // MARK: - Private Methods
    private func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height),
                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0 - (self.bounds.height - cellSize.height)).isActive = true
        self.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0).isActive = true

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: String(describing: DialCollectionViewCell.self), bundle: Bundle(for: SectionDialView.self)), forCellWithReuseIdentifier: DialCollectionViewCell.identifier)

        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SectionDialView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfElements(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DialCollectionViewCell.identifier, for: indexPath) as! DialCollectionViewCell
        if let config = cellConfiguration {
            cell.config = config
        }
        cell.setupTitle(delegate?.dialView(self, elementTitleAtIndex: indexPath.row) ?? "No data")
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension SectionDialView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            scrollToCenterOfItem()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && scrollView == collectionView
        {
            scrollToCenterOfItem()
        }
    }
    
    private func scrollToCenterOfItem() {
        var curentCellOffset = collectionView.contentOffset
        curentCellOffset.x += collectionView.frame.width / 2
        if let indexPath = collectionView.indexPathForItem(at: curentCellOffset) {
            selectedIndex = indexPath.row
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SectionDialView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = collectionView.frame.width / 2 - cellSize.width / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}
