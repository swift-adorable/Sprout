//
//  TermsOfServicePartView.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/18.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import RxSwift

protocol TermsOfServicePartViewDelegate: AnyObject {
    func isCheckedButton(type: TermsOfServiceType, isSelected: Bool)
}

class TermsOfServicePartView: UIView {
    
    //MARK: UI Property
    private let checkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_nor"), for: .normal)
        btn.setImage(UIImage(named: "check_sel"), for: .selected)
        return btn
    }()
    
    private let descriptLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        return lb
    }()
    
    private let showDetailButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "arrow_right"), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return btn
    }()
    
    //MARK: Value Property
    weak var delegate: TermsOfServicePartViewDelegate?
    
    private var type: TermsOfServiceType?
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
}

extension TermsOfServicePartView {
    private func setupView() {
        addSubview(checkButton)
        connectToAnchor(child: checkButton, top: 0, left: 0, bottom: 0)
        checkButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(descriptLabel)
        connectToAnchor(child: descriptLabel, top: 0, bottom: 0)
        descriptLabel.leftAnchor.constraint(equalTo: checkButton.rightAnchor, constant: 10).isActive = true
        
        addSubview(showDetailButton)
        connectToAnchor(child: showDetailButton, right: 0)
        showDetailButton.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
        showDetailButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        showDetailButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        descriptLabel.rightAnchor.constraint(greaterThanOrEqualTo: showDetailButton.leftAnchor, constant: 10).isActive = true
        
        //MARK: Binding
        bind()
    }
    
    func update(_ type: TermsOfServiceType) {
        self.type = type
        descriptLabel.attributedText = type.descriptAttrText
        showDetailButton.isHidden = type.isHiddenShowDetail
    }
    
    fileprivate func bind() {
        checkButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let delegate = self?.delegate, let type = self?.type else { return }
                self?.checkButton.isSelected.toggle()
                let isSelected = self?.checkButton.isSelected ?? false
                delegate.isCheckedButton(type: type, isSelected: isSelected)
            }).disposed(by: disposeBag)
    }
}

extension TermsOfServicePartView: TermsOfServiceViewDelegate {
    func checkedAllAgree(isSelected: Bool) {
        DEBUG_LOG("TEST!! type: \(self.type), isSelected: \(isSelected)")
        self.checkButton.isSelected = isSelected
    }
}
