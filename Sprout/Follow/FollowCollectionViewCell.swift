//
//  FollowCollectionViewCell.swift
//  Sprout
//
//  Created by Blanc on 2022/11/11.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

class FollowCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileMessageLabel: UILabel!
    @IBOutlet weak var unfollowButton: UIButton!
    
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
        
        let btnImage = urlString.count % 2 == 0 ? UIImage(named: "follow") : UIImage(named: "unfollow")
        unfollowButton.setImage(btnImage, for: .normal)
    }
    
}

extension FollowCollectionViewCell {
    func configureInit() {
        
        profileImageView.layer.cornerRadius = 30
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
