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
    public var config: SectionDialViewSettings = SectionDialViewSettings() {
        didSet {
            if oldValue.cellSize != config.cellSize {
                resetViewLayout()
            }
        }
    }
    public var selectedIndex: Int = -1 {
        didSet {
            futureIndex = selectedIndex
            if timer != nil{
                stopTimer()
            }
            delegate?.dialView(self, didSelectElementAt: selectedIndex)
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            if futureIndex != selectedIndex {
                resetViewLayout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.setSelectedIndex(self.futureIndex, withAnimation: self.animated)
                }
            }
        }
    }
    
    public func setSelectedIndex(_ index: Int, withAnimation animated: Bool) {
        futureIndex = index
        self.animated = animated
        
        if isSelectedIndexPath == false && timer == nil  {
            startTimer()
        }
        
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0) , at: .centeredHorizontally, animated: animated)
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public func viewDidLayoutSubviews() {
        resetViewLayout()
    }
    
    // MARK: - Constructors
    required convenience public init(frame: CGRect, delegate: SectionDialViewDelegate? = nil, config: SectionDialViewSettings? = nil) {
        self.init(frame: frame)

        if let delegate = delegate {
            self.delegate = delegate
        }
        if let config = config {
            self.config = config
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
    private var collectionView: UICollectionView!
    private var futureIndex = -1
    private var animated = false
    private var timer: Timer?
    
    // MARK: - View Lifecycle
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.clear(rect)

        let markRect = CGRect(x: (bounds.size.width / 2) - (config.centerMarkSize.width / 2),
                              y: 0,
                              width: config.centerMarkSize.width,
                              height: config.centerMarkSize.height)
        let path = UIBezierPath(roundedRect: markRect,
                                cornerRadius: 1.0)
        
        ctx.addPath(path.cgPath)
        ctx.fillPath()
    }
    
    // MARK: - Private Methods
    private func initCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height),
                                          collectionViewLayout: UICollectionViewFlowLayout(cellSize: config.cellSize))
        self.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["collection": collectionView!]
        let h = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collection]-0-|", metrics: nil, views: views)
        let w = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collection]-0-|", metrics: nil, views: views)
        NSLayoutConstraint.activate(h + w)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: String(describing: DialCollectionViewCell.self), bundle: Bundle(for: SectionDialView.self)), forCellWithReuseIdentifier: DialCollectionViewCell.identifier)
        
        setupViewLayout()
    }
    
    private func resetViewLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        setupViewLayout()
    }
    
    private func setupViewLayout() {
        let insetValue = self.frame.width / 2 - config.cellSize.width / 2
        let inset = UIEdgeInsets(top: 0, left: insetValue, bottom: 0, right: insetValue)
                
        collectionView.collectionViewLayout = UICollectionViewFlowLayout(cellSize: config.cellSize, sectionInset: inset)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            if strongSelf.isSelectedIndexPath {
                strongSelf.stopTimer()
            } else if strongSelf.collectionView.indexPathsForVisibleItems.map({ $0.row }).contains(strongSelf.futureIndex) {
                strongSelf.selectedIndex = strongSelf.futureIndex
            }
        })
    }
}

// MARK: - UICollectionViewDataSource
extension SectionDialView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfElements(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DialCollectionViewCell.identifier, for: indexPath) as! DialCollectionViewCell
        if let config = config.cellConfiguration {
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
        if !decelerate && scrollView == collectionView {
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

extension SectionDialView: UICollectionViewDelegate {
}

extension SectionDialView {
    var isSelectedIndexPath: Bool {
        return selectedIndex > 0
    }
}
