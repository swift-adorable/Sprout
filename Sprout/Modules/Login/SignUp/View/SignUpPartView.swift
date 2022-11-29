//
//  SignUpPartView.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/17.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class SignUpPartView: UIView {
    
    //MARK: UI Property
    private let descriptLabel = UILabel()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.layer.addBasicBorder(color: .systemGray3, cornerRadius: 5)
        tf.spellCheckingType = .no
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
    
    private let isSecureButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "password_lock"), for: .normal)
        btn.setImage(UIImage(named: "password_unlock"), for: .selected)
        btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return btn
    }()
    
    private let errorMessageLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .red
        lb.font = .systemFont(ofSize: 12, weight: .medium)
        return lb
    }()
    
    //MARK: Value Property
    private var type: SignUpInputType = .Email
    var textAtEndEditing: BehaviorSubject<(SignUpInputType, String?)> = BehaviorSubject(value: (.Email, ""))
    
    private var disposeBag = DisposeBag()
    
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
    
    func update(_ type: SignUpInputType) {
        self.type = type
        descriptLabel.attributedText = type.descriptAttrText
        textField.placeholder = type.placeholder
        textField.textContentType = type.textContentType
        textField.keyboardType = type.keyboardType
        textField.isSecureTextEntry = type.isSecureTextEntry
        duplicateCheckButton.isHidden = !type.isNeedsDuplicateCheck
        isSecureButton.isHidden = type == .Email || type == .Nickname
    }
    
    func isMatchType(_ type: SignUpInputType) -> Bool {
        return type == self.type
    }
    
    func showErrorMessage(_ error: String) {
        errorMessageLabel.text = error
    }
    
    fileprivate func bind() {
        
        textField.rx.textAtEndEditing
            .subscribe(onNext: { [weak self] (text) in
                guard let `self` = self else { return }
                self.textAtEndEditing.onNext((self.type, text))
            })
            .disposed(by: disposeBag)
        
        isSecureButton.rx.tap.debug("")
            .asDriver(onErrorJustReturn: ())
            .drive { [weak self] _ in
                self?.isSecureButton.isSelected.toggle()
                self?.textField.isSecureTextEntry = !(self?.isSecureButton.isSelected ?? true)
                self?.textField.becomeFirstResponder()
            }.disposed(by: disposeBag)
        
    }
}

extension SignUpPartView {
    private func setupView() {
        
        addSubview(descriptLabel)
        connectToAnchor(child: descriptLabel, top: 4, left: 24)
        descriptLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        horizontalStackView.addArrangedSubview(textField)
        horizontalStackView.addArrangedSubview(duplicateCheckButton)
        duplicateCheckButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(horizontalStackView)
        connectToAnchor(child: horizontalStackView, left: 26, right: -26)
        horizontalStackView.topAnchor.constraint(equalTo: descriptLabel.bottomAnchor, constant: 7).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        addSubview(isSecureButton)
        textField.connectToAnchor(child: isSecureButton, right: -6)
        isSecureButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        isSecureButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        isSecureButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(errorMessageLabel)
        connectToAnchor(child: errorMessageLabel, left: 28, bottom: -4, right: -16)
        errorMessageLabel.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 4).isActive = true
        errorMessageLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        bind()
    }
}
