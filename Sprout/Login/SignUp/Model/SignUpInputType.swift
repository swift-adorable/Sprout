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
}

//MARK: Regex Expression

extension SignUpInputType {
    var regexExpressionPattern: String {
        switch self {
        case .Email:
            return "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        case .Password:
            return "[A-Za-z0-9]{8,12}"
        case .DuplicatePassword:
            return "[A-Za-z0-9]{8,12}"
        case .Nickname:
            return "[A-Za-z0-9]{4,16}"
        }
    }
    
    var errorWithCheckRegex: String {
        switch self {
        case .Email:
            return "이메일 형식이 맞지 않습니다."
        case .Password:
            return "비밀번호 형식이 맞지 않습니다."
        case .DuplicatePassword:
            return "비밀번호 형식이 맞지 않습니다."
        case .Nickname:
            return "닉네임 형식이 맞지 않습니다."
        }
    }
}

//MARK: TextField UI Property.

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
        }
    }
    
    var isNeedsDuplicateCheck: Bool {
        return self == .Nickname
    }
    
}

//MARK: TextField UI Property With Interface Builder.

extension SignUpInputType {
    var textContentType: UITextContentType? {
        switch self {
        case .Email:
            return .emailAddress
        default:
            return nil
        }
    }
    
    var isSecureTextEntry: Bool {
        return self == .Password || self == .DuplicatePassword
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
            
        case .Email:
            return .emailAddress
        default:
            return .default
        }
    }
}
