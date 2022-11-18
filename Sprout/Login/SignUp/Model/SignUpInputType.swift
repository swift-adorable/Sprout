//
//  SignUpInputType.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/17.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

public enum SignUpInputType: CaseIterable {
    case Email
    case Password
    case DuplicatePassword
    case Nickname
    case Unknown
}

extension SignUpInputType {
    
    fileprivate var _descrptionText: String {
        switch self {
            
        case .Email:
            return "이메일"
        case .Password:
            return "비밀번호"
        case .DuplicatePassword:
            return "비밀번호 확인"
        case .Nickname:
            return "닉네임"
        case .Unknown:
            return ""
        }
    }
    
    var descriptAttrText: NSMutableAttributedString {
        let titleText = self._descrptionText
        let titleAttrText = NSMutableAttributedString(string: titleText,
                                                      attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)])
        
        let spacing = NSMutableAttributedString(string: " ",
                                              attributes: [.font: UIFont.systemFont(ofSize: 5, weight: .semibold)])
        
        let point = NSMutableAttributedString(string: "*",
                                              attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                           .foregroundColor: UIColor.red])
        titleAttrText.append(spacing)
        titleAttrText.append(point)
        return titleAttrText
    }
    
    var placeholder: String {
        switch self {
            
        case .Email:
            return "이메일을 입력해주세요"
        case .Password:
            return "비밀번호를 입력해주세요"
        case .DuplicatePassword:
            return "비밀번호를 한번 더 입력해주세요"
        case .Nickname:
            return "닉네임을 입력해주세요"
        case .Unknown:
            return ""
        }
    }
    
    var isNeedsDuplicateCheck: Bool {
        return self == .Nickname
    }
    
}
