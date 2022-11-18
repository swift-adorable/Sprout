//
//  TermsOfServiceType.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/18.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

enum TermsOfServiceType: CaseIterable {
    case PersonalInfo
    case OptionalInfo
    case TermsOfService
    case Fourteen
}

extension TermsOfServiceType {
    
    fileprivate var _descrptionText: String {
        switch self {
        case .PersonalInfo:
            return "개인정보 수집 및 이용 동의"
        case .OptionalInfo:
            return "선택정보 수집 및 이용 동의"
        case .TermsOfService:
            return "이용약관 동의"
        case .Fourteen:
            return "본인은 만 14세 이상입니다."
        
        }
    }
    
    var descriptAttrText: NSMutableAttributedString {
        let titleText = self._descrptionText
        let titleAttrText = NSMutableAttributedString(string: titleText,
                                                      attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)])
        
        
        let spacing = NSMutableAttributedString(string: " ",
                                              attributes: [.font: UIFont.systemFont(ofSize: 5, weight: .semibold)])
        
        let subTitleText = isNeeded ? "(필수)" : "(선택)"
        let subTitleAttrText = NSMutableAttributedString(string: subTitleText,
                                                         attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                                      .foregroundColor: UIColor.systemGray2])
        titleAttrText.append(spacing)
        titleAttrText.append(subTitleAttrText)
        return titleAttrText
    }
    
    var isNeeded: Bool {
        return self != .OptionalInfo
    }
    
    var isHiddenShowDetail: Bool {
        return self == .Fourteen
    }
}
