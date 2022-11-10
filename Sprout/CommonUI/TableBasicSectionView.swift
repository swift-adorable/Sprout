//
//  TableBasicSectionView.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

protocol FieldSectionHeaderDelegate: AnyObject {
    func tappedSectionIndex(index: Int)
}

class TableBasicSectionView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    
    private var upDownFlag: Bool = false
    private var sectionIndex: Int = 0
    weak var delegate: FieldSectionHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView(){
        if let view = Bundle.main.loadNibNamed("TableBasicSectionView", owner: self, options: nil)!.first as? UIView {
            view.frame = self.bounds
            view.layoutIfNeeded()
            self.addSubview(view)
            addTapGesture()
        }
    }
    
}

extension TableBasicSectionView {
    
    func updateView(title: String, index: Int, isSelected: Bool) {
        titleLabel.text = title
        sectionIndex = index
        
        let degree: CGFloat = !isSelected ? 0.0 : 180.0
        
        UIView.animate(withDuration: 0.4) {
            self.imageView.transform = CGAffineTransform(rotationAngle: (degree * CGFloat(Double.pi)) / 180.0)
        }
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(tappedSectionView))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedSectionView() {
        
        let degree: CGFloat = upDownFlag ? 0.0 : 180.0
        
        upDownFlag = !upDownFlag
        
        UIView.animate(withDuration: 0.4) {
            self.imageView.transform = CGAffineTransform(rotationAngle: (degree * CGFloat(Double.pi)) / 180.0)
        }
        
        delegate?.tappedSectionIndex(index: sectionIndex)
    }
    
}
