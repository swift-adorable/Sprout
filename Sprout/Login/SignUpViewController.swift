//
//  SignUpViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailAlertLabel: PaddingLabel!
    
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdAlertLabel: PaddingLabel!
    
    @IBOutlet weak var pwdCheckTextField: UITextField!
    @IBOutlet weak var pwdCheckAlertLabel: PaddingLabel!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameAlertLabel: PaddingLabel!
    
    @IBOutlet weak var completeButton: UIButton!
    
    var photoModelSubject: BehaviorSubject<[PostPhotoModel]> = BehaviorSubject(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializedConfigure()
//        bindToReactor()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let color: UIColor = .signatureNWhite
        emailTextField.layer.borderColor = color.cgColor
        pwdTextField.layer.borderColor = color.cgColor
        pwdCheckTextField.layer.borderColor = color.cgColor
        nickNameTextField.layer.borderColor = color.cgColor
        profileImage.layer.borderColor = color.withAlphaComponent(0.2).cgColor
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

//extension SignUpViewController {
//
//    func bind(reactor: SignUpReactor) {
//
//        reactor.state // 이메일
//            .do(onNext: { [weak self] _ in self?.emailAlertLabel.isHidden = !reactor.isEmailAlert })
//            .filter { _ in reactor.isEmailAlert }
//            .map { $0.emailAlertText }
//            .bind(to: emailAlertLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        reactor.state // 닉네임
//            .do(onNext: { [weak self] _ in self?.nickNameAlertLabel.isHidden = !reactor.isNickNameAlert })
//            .filter { _ in reactor.isNickNameAlert }
//            .map { $0.nicknameAlertText }
//            .bind(to: nickNameAlertLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        reactor.state
//            .filter { $0.doneEnable }
//            .map { $0.doneEnable }
//            .subscribe(onNext: { [weak self] isEnable in
//                self?.completeButton.isEnabled = isEnable
//                self?.completeButton.backgroundColor = .signatureNWhite
//            }).disposed(by: disposeBag)
//
//        reactor.state
//            .filter { $0.completedSignUp }
//            .subscribe(onNext: { [weak self] _ in
//                self?.dismiss(animated: true, completion: nil)
//            }).disposed(by: disposeBag)
//
//    }
//
//    private func bindToReactor() {
//        guard let reactor = reactor else { return }
//
//        emailTextField.rx.text.orEmpty
//            .map { Reactor.Action.emailEdited($0) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        pwdTextField.rx.text.orEmpty
//            .map { Reactor.Action.pwdEdited($0) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        pwdCheckTextField.rx.text.orEmpty
//            .map { Reactor.Action.pwdCheckEdited($0) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        nickNameTextField.rx.controlEvent(.editingDidEnd)
//            .withLatestFrom(nickNameTextField.rx.text.orEmpty)
//            .map { Reactor.Action.nicknameEdited($0) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        completeButton.rx.tap
//            .debounce(RxTimeInterval.seconds(2), scheduler: MainScheduler.asyncInstance)
//            .map { Reactor.Action.completedSignUp }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        profileButton.rx.tap
//            .debounce(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//                PhotoManager.shared.photoModelSubject = self.photoModelSubject
//                PhotoManager.shared.showPicker(self, maxNumberOfItems: 1)
//            }).disposed(by: disposeBag)
//
//        photoModelSubject.debug("Selected Profile Image")
//            .filter { $0.count > 0 }
//            .do(onNext: { [weak self] data in
//                let placeHolder = UIImage(named: "User_Guest")
//                let isGIFPhoto: Bool = data[0].url.absoluteString.contains("GIF")
//
//                if isGIFPhoto {
//                    self?.profileImage.kf.setImage(with: data[0].url, placeholder: placeHolder, completionHandler: { result in
//                        switch result {
//                        case .success(_): break
//                        case .failure(_): self?.profileImage.image = UIImage(data: data[0].photoData)
//                        }
//                    })
//                } else {
//                    self?.profileImage.image = UIImage(data: data[0].photoData)
//                }
//            }).map { Reactor.Action.uploadProfileImage($0[0]) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//    }
//
//}

extension SignUpViewController {
    private func initializedConfigure() {
        //self.reactor = SignUpReactor()
        let color = UIColor.signatureNWhite
        completeButton.isEnabled = false
        completeButton.backgroundColor = color.withAlphaComponent(0.6)
        completeButton.layer.addBasicBorder(color: .clear, width: 0.5, cornerRadius: 5)
        emailTextField.layer.addBasicBorder(color: color, width: 0.5, cornerRadius: 5)
        pwdTextField.layer.addBasicBorder(color: color, width: 0.5, cornerRadius: 5)
        pwdCheckTextField.layer.addBasicBorder(color: color, width: 0.5, cornerRadius: 5)
        nickNameTextField.layer.addBasicBorder(color: color, width: 0.5, cornerRadius: 5)
        profileImage.layer.addBasicBorder(color: color.withAlphaComponent(0.2), width: 2, cornerRadius: 27)

    }
}

