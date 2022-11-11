//
//  FollowViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

class FollowViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var words: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        let space: CGFloat = 8
        collectionView.contentInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        
        App.api.randomWord(nums: 20) { [weak self] (words) in
            guard let `self` = self else { return }
            self.words = words
            
            self.collectionView.reloadData()
        }
        
    }
    
}

extension FollowViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCollectionViewCell", for: indexPath) as! FollowCollectionViewCell
        cell.updateCell(urlString: words[indexPath.row])
        return cell
    }
    
}

extension FollowViewController: UICollectionViewDelegateFlowLayout {
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let appWidth = APP_WIDTH() - 16
        return CGSize(width: appWidth, height: 80)
    }
    
    //CollectionView Inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let space: CGFloat = 8
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    //Top & Bottom Margin Between Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    //Side Margin Between Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
}
