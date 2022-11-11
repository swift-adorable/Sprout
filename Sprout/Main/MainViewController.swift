//
//  MainViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MainViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gridButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var flag: Bool = true
    var csvTestIndex = 0
    
    private var words: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        App.api.randomWord(nums: 20) { [weak self] (words) in
            guard let `self` = self else { return }
            self.words = words
            
            self.collectionView.reloadData()
        }
        
        buttonBind()
        
        self.readFile(fileName: "City", fileType: "txt")
        
    }
    
}

extension MainViewController {
    
    func buttonBind () {
        gridButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.flag = !self.flag
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        filterButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                let viewController = MainFilterViewController.viewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.debug()
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                let viewController = UserProfileViewController.viewController("Follow")
                
                let panModalViewController: PanModalPresentable.LayoutType = viewController
                self.presentPanModal(panModalViewController)
                
            }).disposed(by: disposeBag)
        
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if flag {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainHorizontalCell", for: indexPath) as! MainHorizontalCell
            cell.updateCell(urlString: words[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFullCell", for: indexPath) as! MainFullCell
            cell.updateCell(urlString: words[indexPath.row])
            return cell
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if flag {
            let appWidth = APP_WIDTH() - 16
            return CGSize(width: appWidth, height: 100)
        } else {
            let appWidth = APP_WIDTH() - 16
            return CGSize(width: appWidth, height: appWidth)
        }
    }
    
    //CollectionView Inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let sideSpace = (36 * APP_WIDTH()) / 414
//        return UIEdgeInsets(top: 26, left: sideSpace, bottom: 32, right: sideSpace)
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

extension MainViewController {
    
    func readFile(fileName: String, fileType: String) {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                let parsedFile: [String] = content.components(separatedBy: "\n").map{ $0.replacingOccurrences(of: "\r", with: "") } //띄어쓰기 구분
                var bufferFileData = parsedFile.map { $0.components(separatedBy: ",").uniques }
                bufferFileData = bufferFileData.filter { $0.count > 2 }
                
                bufferFileData.map { data in
                    data.forEach {
                        if $0.contains("읍") || $0.contains("면") {
                            
                        }
                        
                    }
                }
                
            } catch(let error) {
                DEBUG_LOG(error.localizedDescription)
            }
        } else {
            DEBUG_LOG("File dosen't exist!!")
        }
        
        
    }
    
}
