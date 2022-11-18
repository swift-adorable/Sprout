//
//  TermsOfServiceView.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/18.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import RxSwift

class TermsOfServiceView: UIView {
    
    //MARK: UI Property
    private let titleLabel: UILabel = {
        let lb = UILabel()
        let titleAttrText = NSMutableAttributedString(string: "이용약관동의",
                                                      attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)])
        
        let spacing = NSMutableAttributedString(string: " ",
                                              attributes: [.font: UIFont.systemFont(ofSize: 5, weight: .semibold)])
        
        let point = NSMutableAttributedString(string: "*",
                                              attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                           .foregroundColor: UIColor.red])
        titleAttrText.append(spacing)
        titleAttrText.append(point)
        lb.attributedText = titleAttrText
        return lb
    }()
    
    private let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let checkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_nor"), for: .normal)
        btn.setImage(UIImage(named: "check_sel"), for: .selected)
        return btn
    }()
    
    private let agreeOfAllLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 17, weight: .bold)
        lb.text = "전체 동의합니다."
        return lb
    }()
    
    private let descriptLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.font = .systemFont(ofSize: 13, weight: .regular)
        lb.textColor = .systemGray3
        lb.text = "선택 항목에 동의하지 않은 경우도 회원가입 및 일반적인 서비스를 이용하실 수 있습니다."
        return lb
    }()
    
    //MARK: Value Property
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
}

extension TermsOfServiceView {
    private func setupView() {
        addSubview(titleLabel)
        connectToAnchor(child: titleLabel, top: 16, left: 24)
        
        addSubview(checkButton)
        connectToAnchor(child: checkButton, left: 26)
        checkButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        checkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        
        addSubview(agreeOfAllLabel)
        agreeOfAllLabel.translatesAutoresizingMaskIntoConstraints = false
        agreeOfAllLabel.leftAnchor.constraint(equalTo: checkButton.rightAnchor, constant: 10).isActive = true
        agreeOfAllLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
        
        addSubview(descriptLabel)
        connectToAnchor(child: descriptLabel, left: 26, right: -26)
        descriptLabel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 10).isActive = true
        
        let seperateLine = UILabel()
        seperateLine.backgroundColor = .systemGray5
        addSubview(seperateLine)
        connectToAnchor(child: seperateLine, left: 26, right: -26)
        seperateLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        seperateLine.topAnchor.constraint(equalTo: descriptLabel.bottomAnchor, constant: 10).isActive = true
    
        TermsOfServiceType.allCases.forEach { type in
            let partView = TermsOfServicePartView()
            partView.frame = CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 34)
            partView.update(type)
            partView.translatesAutoresizingMaskIntoConstraints = false
            partView.heightAnchor.constraint(equalToConstant: 34).isActive = true
            verticalStackView.addArrangedSubview(partView)
        }
        
        addSubview(verticalStackView)
        connectToAnchor(child: verticalStackView, left: 26, bottom: 0, right: -26)
        verticalStackView.topAnchor.constraint(equalTo: seperateLine.bottomAnchor, constant: 10).isActive = true
    }
    
}
