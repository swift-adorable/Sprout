//
//  MenuView.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

protocol MenuViewDelegate: AnyObject {
    func scrollMenuViewSelectedIndex(_ view: MenuView, index: Int)
}

class MenuView: UIView {
    
    private let kYSLScrollMenuViewMargin:CGFloat = 12
    
    lazy var scrollView = UIScrollView()
    
    weak var delegate: MenuViewDelegate?
    
    var titles: Array<String> = []
    var labels: Array<UILabel> = []
    
    var titleWidth: CGFloat = 0.0
    
    var itemFont: UIFont = UIFont.systemFont(ofSize: 13)
    var itemSelectedFont: UIFont = UIFont.boldSystemFont(ofSize: 13)
    
    var itemColor: UIColor = UIColor.colorFromRGB(0xffffff, alpha: 0.6)
    var itemSelectedColor: UIColor = UIColor.white
    
    deinit { DEBUG_LOG("MenuView deinit!!!!!") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 0
        let scrollViewHeight = self.scrollView.frame.size.height
        
        if self.frame.size.width < self.titleWidth {
            x = kYSLScrollMenuViewMargin
            
            for label in self.labels {
                let width: CGFloat = label.frame.size.width
                label.frame = CGRect.init(x: x, y: 0, width: width, height: scrollViewHeight)
                x += width + kYSLScrollMenuViewMargin
            }
        
        }else {
            x = 0
            let count: Int = self.labels.count
            let sizeWidth: CGFloat = APP_WIDTH()
            let width: CGFloat = sizeWidth / CGFloat(count)
            
            for label in self.labels {
                label.frame = CGRect.init(x: x, y: 0, width: width, height: scrollViewHeight)
                x += width
            }
        }
        self.scrollView.contentSize = CGSize.init(width: x, height: scrollViewHeight)
        var frame: CGRect = self.scrollView.frame
        
        frame.origin.x = 0
        frame.size.width = self.frame.size.width
        
        self.scrollView.frame = frame
    }
    
    func setupView() {
        self.scrollView.frame = self.bounds
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
    }
    
}

extension MenuView {
    
    func changeScrollPosition(_ frame : CGRect){
        
        var offsetX = frame.origin.x - ((APP_WIDTH()-frame.size.width)/2)
        let offsetWidth = self.scrollView.contentSize.width - offsetX
        
        if offsetX < 0 { offsetX = 0 }
        
        if (offsetWidth - self.scrollView.frame.size.width) < 0 {
            offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width
        }
        
        self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    func setTitles(titles: Array<String>) {
        if self.titles != titles {
            self.scrollView.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            self.scrollView.removeFromSuperview()
            self.labels.removeAll()
            
            self.titleWidth = 0
            var allTitleWidth:CGFloat = 0
            
            self.titles = titles
            var tempLabels: Array<UILabel> = []
            for (index, title) in self.titles.enumerated() {
                //let titleLocalizedString = LocalizedString(title, comment: "메뉴명")
                let titleSize:CGSize = (title as NSString).size(withAttributes: [.font : UIFont.boldSystemFont(ofSize: 13)])
                let frame: CGRect = CGRect.init(x: 0, y: 0, width: titleSize.width + 20, height: titleSize.height)
                
                allTitleWidth += titleSize.width + self.kYSLScrollMenuViewMargin + 20
                
                let label = UILabel(frame: frame)
                self.scrollView.addSubview(label)
                label.tag = index
                label.text = title
                label.isUserInteractionEnabled = true
                label.backgroundColor = .clear
                label.textAlignment = .center
                label.font = self.itemSelectedFont
                label.textColor = itemColor
                
                tempLabels.append(label)
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(labelTapAction(_:)))
                
                label.addGestureRecognizer(tapGesture)
            }
            
            allTitleWidth += 24
            
            self.titleWidth = allTitleWidth
            self.labels = tempLabels
            self.addSubview(self.scrollView)
            
            self.layoutSubviews()
        }
    }
    
    @objc func labelTapAction(_ recognizer: UITapGestureRecognizer) {
        guard let index = recognizer.view?.tag else { return }
        if let delegate = self.delegate {
            delegate.scrollMenuViewSelectedIndex(self, index: index)
        }
    }
    
    func changeTextColorAtIndex(selectedIndex: Int) {
        for (index, label) in self.labels.enumerated() {
            label.textColor = index == selectedIndex ? itemSelectedColor : itemColor
            label.font = index == selectedIndex ? itemSelectedFont : itemFont
        }
    }
    
}
