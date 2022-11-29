//
//  SelectLoginViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift

class SelectLoginViewController: BaseViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var kakaoTalkButton: UIButton!
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var emailSignUpButton: UIButton!
    @IBOutlet weak var lookAroundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializedConfigure()
        buttonBind()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let color: UIColor = .blackNWhite
        googleButton.layer.borderColor = color.cgColor
        appleButton.layer.borderColor = color.cgColor
    }

    static func viewController(_ closeIsHidden: Bool) -> SelectLoginViewController {
        let viewController = SelectLoginViewController.viewController("Login")
        viewController.closeButton.isEnabled = !closeIsHidden
        viewController.closeButton.image = closeIsHidden ? nil : UIImage(named: "Navi_Close")
        return viewController
    }
}

extension SelectLoginViewController {
    private func buttonBind() {
        lookAroundButton.rx.tap
            .flatMap { [weak self] _ -> Observable<Bool> in
                guard let `self` = self else { return Observable.empty() }
                return self.rx.showBasicAlert(title: "둘러보시겠습니까?")
            }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
            
    }
}

extension SelectLoginViewController {
    func initializedConfigure() {
        googleButton.layer.addBasicBorder(color: .blackNWhite, width: 1, cornerRadius: 5)
        kakaoTalkButton.layer.cornerRadius = 5
        naverButton.layer.cornerRadius = 5
        facebookButton.layer.cornerRadius = 5
        appleButton.layer.addBasicBorder(color: .blackNWhite, width: 1, cornerRadius: 5)
    }
}
