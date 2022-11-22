//
//  ScrollingMenuView.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

protocol ScrollingMenuViewDelegate: AnyObject {
    func selectedIndexWithMenuView(_ view: ScrollingMenuView, index: Int)
}

class ScrollingMenuView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollIndicatorView: UIView!
    @IBOutlet weak var indicatorXPosition: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConst: NSLayoutConstraint!
    
    private var unSelectedItemFont: UIFont = .systemFont(ofSize: 12)
    private var selectedItemFont: UIFont = .boldSystemFont(ofSize: 14)
    
    private var unSelectedItemFontColor: UIColor = .blackNWhite
    private var selectedItemFontColor: UIColor = .signatureNWhite
    
    private var indicatorColor: UIColor = .signatureNWhite
    
    private let kYSLScrollMenuViewMargin: CGFloat = 12
    
    lazy private var titles: [String] = []
    lazy private var labels: [UILabel] = []
    lazy private var labelWidths: [CGFloat] = []
    
    private var titleWidth: CGFloat = 0.0
    
    weak var delegate: ScrollingMenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configureInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 0
        let scrollViewHeight = self.scrollView.frame.size.height
        labelWidths = []
        
        if self.frame.size.width < self.titleWidth {
            x = kYSLScrollMenuViewMargin
            
            for label in self.labels {
                let width: CGFloat = label.frame.size.width
                labelWidths.append(width)
                label.frame = CGRect.init(x: x, y: 0, width: width, height: scrollViewHeight)
                x += width + kYSLScrollMenuViewMargin
            }
        
        }else {
            x = 0
            let count: Int = self.labels.count
            let sizeWidth: CGFloat = APP_WIDTH()
            let width: CGFloat = sizeWidth / CGFloat(count)
            
            for label in self.labels {
                labelWidths.append(width)
                label.frame = CGRect.init(x: x, y: 0, width: width, height: scrollViewHeight)
                x += width
            }
        }
        
        self.scrollView.contentSize = CGSize.init(width: x, height: scrollViewHeight)
        var frame: CGRect = self.scrollView.frame
        
        frame.origin.x = 0
        frame.size.width = self.frame.size.width
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.frame = frame
    }
    
    func setupView(){
        if let view = Bundle.main.loadNibNamed("ScrollingMenuView", owner: self, options: nil)!.first as? UIView {
            view.backgroundColor = .init(white: 1, alpha: 0.9)
            view.frame = self.bounds
            view.layoutIfNeeded()
            self.addSubview(view)
            
        }
    }
    
}

extension ScrollingMenuView {
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
            self.labels.removeAll()
            
            self.titleWidth = 0
            var allTitleWidth:CGFloat = 0
            
            self.titles = titles
            var tempLabels: Array<UILabel> = []
            for (index, title) in self.titles.enumerated() {

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
                label.font = unSelectedItemFont
                label.textColor = unSelectedItemFontColor
                
                tempLabels.append(label)
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(labelTapAction(_:)))
                
                label.addGestureRecognizer(tapGesture)
            }
            
            allTitleWidth += 24
            
            self.titleWidth = allTitleWidth
            self.labels = tempLabels
            
            self.layoutSubviews()
        }
    }
    
    @objc func labelTapAction(_ recognizer: UITapGestureRecognizer) {
        guard let index = recognizer.view?.tag else { return }
        if let delegate = self.delegate {
            delegate.selectedIndexWithMenuView(self, index: index)
        }
    }
    
    func changeTextColorAtIndex(selectedIndex: Int) {
        UIView.animate(withDuration: 0.3) {
            for (index, label) in self.labels.enumerated() {
                label.textColor = index == selectedIndex ? self.selectedItemFontColor : self.unSelectedItemFontColor
                label.font = index == selectedIndex ? self.selectedItemFont : self.unSelectedItemFont
            }
            
            self.indicatorWidthConst.constant = self.labelWidths[selectedIndex]
            
        }
    }
    
    func changeScrollBarOffset(with offset: CGPoint?, currentIndex index: Int) {

        if let offset = offset {
            let xPosition = offset.x - APP_WIDTH()
            let isDraggedRight: Bool = xPosition < 0 // 오른쪽으로 드래그 시 true, 왼쪽으로 드래그 시 false
            let labelWidth = labels[index].frame.width
            
            var movedXPosition = (labelWidth * abs(xPosition)) / APP_WIDTH()
            movedXPosition = isDraggedRight ? -(movedXPosition) : movedXPosition
            let calculatedXPosition = self.labelWidths[0..<index].reduce(0, +) + movedXPosition
            
            //DEBUG_LOG("index: \(index), moved: \(movedXPosition), cal: \(calculatedXPosition)")
            self.indicatorXPosition.constant = calculatedXPosition
            
        } else {
            let xPosition = self.labelWidths[0..<index].reduce(0, +)
            self.indicatorXPosition.constant = xPosition
        }
        
    }
    
    func getLabelFrame(_ index: Int) -> CGRect {
        return self.labels[index].frame
    }
    
    func configureInit() {
        scrollView.delegate = self
        scrollIndicatorView.backgroundColor = indicatorColor
    }
    
}

//MARK: - ScrollView Delegate
extension ScrollingMenuView: UIScrollViewDelegate {
    
}


//MARK: - Setting Item Text Font and Text Color
extension ScrollingMenuView {
    
    //MARK: UnSelected Font and Color
    func setUnSelectedItem(textFont: UIFont?, textColor: UIColor?) {
        if let textFont = textFont {
            unSelectedItemFont = textFont
        }
        if let textColor = textColor {
            unSelectedItemFontColor = textColor
        }
    }
    
    
    //MARK: Selected Font and Color
    func setSelectedItem(textFont: UIFont?, textColor: UIColor?) {
        if let textFont = textFont {
            selectedItemFont = textFont
        }
        if let textColor = textColor {
            selectedItemFontColor = textColor
        }
    }
    
    
    //MARK: Indicator Color
    func setIndicatorColor(_ color: UIColor) {
        scrollIndicatorView.backgroundColor = color
    }
    
}
