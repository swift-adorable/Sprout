//
//  SignUpPartView.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/17.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift

class SignUpPartView: UIView {
    
    //MARK: UI Property
    private let descriptLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        return lb
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.layer.addBasicBorder(color: .systemGray3, cornerRadius: 5)
        tf.tintColor = .signature
        tf.font = .systemFont(ofSize: 14, weight: .regular)
        tf.setPaddingLeft(constant: 10)
        return tf
    }()
    
    private let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        return sv
    }()
    
    private let duplicateCheckButton: UIButton = {
        let btn = UIButton()
        let attrTitleText = NSMutableAttributedString(string: "중복확인",
                                                      attributes: [.foregroundColor: UIColor.signature,
                                                                   .font: UIFont.systemFont(ofSize: 14, weight: .semibold)])        
        btn.setAttributedTitle(attrTitleText, for: .normal)
        btn.setTitleColor(.signature, for: .normal)
        btn.layer.addBasicBorder(color: .signature, cornerRadius: 5)
        return btn
    }()
    
    //MARK: Value Property
    private var type: SignUpInputType = .Unknown
    var textAtEndEditing: BehaviorSubject<(SignUpInputType, String?)> = BehaviorSubject(value: (.Unknown, ""))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let wasDarkMode = previousTraitCollection?.userInterfaceStyle == .dark
        let color: UIColor = wasDarkMode ? .systemGray3 : .white
        textField.layer.borderColor = color.cgColor
        
    }
}

extension SignUpPartView {
    private func setupView() {
        addSubview(descriptLabel)
        connectToAnchor(child: descriptLabel, top: 16, left: 24)
        
        horizontalStackView.addArrangedSubview(textField)
        horizontalStackView.addArrangedSubview(duplicateCheckButton)
        duplicateCheckButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(horizontalStackView)
        connectToAnchor(child: horizontalStackView, left: 26, bottom: -4, right: -26)
        horizontalStackView.topAnchor.constraint(equalTo: descriptLabel.bottomAnchor, constant: 7).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        textField.resignFirstResponder()
        
    }
    
    func update(_ type: SignUpInputType) {
        self.type = type
        descriptLabel.attributedText = type.descriptAttrText
        textField.placeholder = type.placeholder
        duplicateCheckButton.isHidden = !type.isNeedsDuplicateCheck
    }
}
