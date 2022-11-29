//
//  MainHorizontalCell.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

class MainHorizontalCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var cityNtimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureInit()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        contentView.layer.borderColor = UIColor(named: "MainCell_BlackNWhite")!.cgColor
        layer.shadowColor = UIColor.blackNWhite.cgColor
    }
    
    func updateCell(urlString: String) {
        
        if let url = urlString.randomImageURL {
            self.profileImageView.kf.setImage(with: url, completionHandler: { result in
                switch result {
                case .success(_): break
                case .failure(_):
                    self.profileImageView.contentMode = .center
                    self.profileImageView.image = UIImage(named: "SignUp_Mentor")
                }
            })
            self.profileImageView.contentMode = .scaleAspectFill
        } else {
            self.profileImageView.contentMode = .center
            self.profileImageView.image = UIImage(named: "SignUp_Mentor")
        }
        
        nicknameLabel.text = urlString
        fieldLabel.text = "연기 / 보컬 / 댄스 - 뮤지컬"
        cityNtimeLabel.text = "서울 - 강남구 & 저녁"

    }
    
}

extension MainHorizontalCell {
    func configureInit() {
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.masksToBounds = true
        
        contentView.layer.addBasicBorder(color: UIColor(named: "MainCell_BlackNWhite")!, width: 2, cornerRadius: 8)
        contentView.layer.masksToBounds = true
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackNWhite.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
                
    }
}
