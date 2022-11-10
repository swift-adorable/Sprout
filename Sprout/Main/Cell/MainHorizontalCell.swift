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
        self.layer.borderColor = UIColor(named: "MainCell_BlackNWhite")!.cgColor
    }
    
    func updateCell() {
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/thestudentbecomethemaster.appspot.com/o/profile_images%2FAA141171-4D75-40FA-80A5-7E77455C12D8?alt=media&token=d837f56e-a351-43ac-b6b3-3ffe90a07046") {
            profileImageView.kf.setImage(with: url, completionHandler: { result in
                switch result {
                case .success(_): break
                case .failure(_):
                    self.profileImageView.contentMode = .center
                    self.profileImageView.image = UIImage(named: "SignUp_Mentor")
                }
            })
            profileImageView.contentMode = .scaleAspectFill
        } else {
            profileImageView.contentMode = .center
            profileImageView.image = UIImage(named: "SignUp_Mentor")
        }
        
        nicknameLabel.text = "Jenny"
        fieldLabel.text = "연기 / 보컬 / 댄스 - 뮤지컬"
        cityNtimeLabel.text = "서울 - 강남구 & 저녁"

    }
    
}

extension MainHorizontalCell {
    func configureInit() {
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.masksToBounds = true
        
        self.layer.addBasicBorder(color: UIColor(named: "MainCell_BlackNWhite")!, width: 2, cornerRadius: 8)
        self.layer.masksToBounds = true
    }
}
