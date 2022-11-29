//
//  LoginViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import Toaster

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializedConfigure()
        bind()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let color = UIColor.signatureNWhite
        emailTextField.layer.borderColor = color.cgColor
        pwdTextField.layer.borderColor = color.cgColor
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoginViewController {
    private func bind() {
        
        loginButton.rx.tap
            .withLatestFrom(emailTextField.rx.text.orEmpty)
            .withLatestFrom(pwdTextField.rx.text.orEmpty) {($0,$1)}
            .flatMap { (email, password) -> Observable<Bool> in
                return FirebaseManager.shared.auth.rx.signIn(email: email, password: password)
            }.filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
    }
    
    private func initializedConfigure() {
        let color = UIColor.signatureNWhite
        emailTextField.layer.addBasicBorder(color: color, width: 0.5, cornerRadius: 5)
        pwdTextField.layer.addBasicBorder(color: color, width: 0.5, cornerRadius: 5)
        loginButton.layer.addBasicBorder(color: color, width: 0.5, cornerRadius: 5)
    }
}
