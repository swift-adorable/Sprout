//
//  BaseViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    lazy var scrollContentOffset: PublishSubject<CGPoint> = PublishSubject()
    lazy var scrollIsEndDrag: PublishSubject<Bool> = PublishSubject()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializedNavigation()
        hideKeyboardWhenTappedAround()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        DEBUG_LOG("Dispose of any resources that can be recreated.")
    }

    deinit{ DEBUG_LOG("Deinit‼️ " + String(describing: Self.self)) }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    fileprivate func initializedNavigation() {
        
        self.navigationController?.navigationBar.tintColor = .signatureNWhite
        self.navigationController?.navigationBar.topItem?.title = "새싹"

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .whiteNBlack
            appearance.titleTextAttributes = [.foregroundColor: UIColor.signatureNWhite,
                                              .font: UIFont.systemFont(ofSize: 17.0, weight: .bold)]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = .whiteNBlack
            self.navigationController?.navigationBar.backgroundColor = .signatureNWhite
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                            .font: UIFont.systemFont(ofSize: 17.0, weight: .bold)]
        }
    }
    
}

extension BaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollContentOffset.onNext(scrollView.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollIsEndDrag.onNext(true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //scrollIsEndDrag.onNext(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollIsEndDrag.onNext(false)
    }
    
}

extension Reactive where Base: BaseViewController {
    func showBasicAlert(title: String = "", message: String = "") -> Observable<Bool> {
        return Observable.create { obs in
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "확인", style: .default) { action in
                obs.onNext(true)
                obs.onCompleted()
            }
            
            let cancelAction = UIAlertAction.init(title: "취소", style: .cancel) { (action) in
                obs.onNext(false)
                obs.onCompleted()
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.base.present(alert, animated: true, completion: nil)
            
            return Disposables.create()
        }
    }
}

extension BaseViewController {
    fileprivate func hideKeyboardWhenTappedAround() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}
