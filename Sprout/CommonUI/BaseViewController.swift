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

    lazy var scrollContentOffset: PublishSubject<(scrollView: UIScrollView?, offset: CGPoint)> = PublishSubject()
    lazy var scrollIsEndDrag: PublishSubject<(scrollView: UIScrollView?, scrollIsEnd: Bool)> = PublishSubject()
    lazy var isDragging: Bool = false
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializedNavigation()
        hideKeyboardWhenTappedAround()
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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
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
        scrollContentOffset.onNext((scrollView, scrollView.contentOffset))
        scrollIsEndDrag.onNext((scrollView, false))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDragging = false
        scrollIsEndDrag.onNext((scrollView, true))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollIsEndDrag.onNext((scrollView, true))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
        scrollIsEndDrag.onNext((scrollView, false))
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
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboardWhenDownScroll))
//        panGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc fileprivate func dismissKeyboardWhenDownScroll(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.verticalDirection(target: self.view) == .Down {
            view.endEditing(true)
        }
    }
}
