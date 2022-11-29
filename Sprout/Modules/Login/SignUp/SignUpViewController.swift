//
//  SignUpViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxKeyboard
import Kingfisher

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var completeButtonBottomAnchor: NSLayoutConstraint!
    
    private var photo: BehaviorSubject<[Photo]> = BehaviorSubject(value: [])
    private var textAtEndEditing: BehaviorSubject<(SignUpInputType, String?)> = BehaviorSubject(value: (.Email, ""))
    private var agreementState = PublishSubject<[TermsOfServiceType: Bool]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignUpViewModel()
        
        initializedConfigure()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SignUpViewController: ViewModel {
    func bind(viewModel: SignUpViewModel) {
        
        //MARK: ViewModel Binding
        
        input = ViewModel.Input(done: completeButton.rx.tap.asObservable(),
                                textFieldText: textAtEndEditing,
                                agreementState: agreementState)
//                                //photo: photo)

        output?.resultMessage
            .subscribe(onNext: { text in
                //DEBUG_LOG("TEST!! output?.resultMessage: \(text)")
            }).disposed(by: disposeBag)
        
        output?.errorMessage
            .asDriver(onErrorJustReturn: (.Email, ""))
            .drive { [weak self] (type, error) in
                guard let `self` = self, let error else { return }
                guard let inputView = self.stackView.subviews
                    .filter ({ $0 is SignUpPartView })
                    .filter({ ($0 as! SignUpPartView).isMatchType(type) }).first as? SignUpPartView else { return }
                
                inputView.showErrorMessage(error)
                
            }.disposed(by: disposeBag)

        output?.currentUserData
            .subscribe(onNext: { user in
                //DEBUG_LOG("TEST!! output?.currentUserData: \(user)")
            }).disposed(by: disposeBag)
        
//        output?.profileImage
//            .asDriver(onErrorJustReturn: nil)
//            .drive(profileImage.rx.setImage)
//            .disposed(by: disposeBag)
        
        //MARK: Outlet Binding
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .asDriver(onErrorJustReturn: .zero)
            .drive(onNext: { [weak self] (visibleHeight) in
                let height = visibleHeight <= .zero ? 30 : visibleHeight - 30
                UIView.animate(withDuration: 0.4) {
                    self?.completeButtonBottomAnchor.constant = height
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
        
//        profileButton.rx.tap
//            .subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//                PhotoManager.shared.photo = self.photo
//                PhotoManager.shared.showPicker(self, maxNumberOfItems: 1)
//            }).disposed(by: disposeBag)
        
    }
}

extension SignUpViewController {
    
    private func initializedConfigure() {
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        completeButton.layer.addBasicBorder(color: .clear, width: 0.5, cornerRadius: 5)
                
        SignUpInputType.allCases.forEach { item in
            let partView = SignUpPartView()
            partView.textAtEndEditing = self.textAtEndEditing
            partView.update(item)
            partView.translatesAutoresizingMaskIntoConstraints = false
            partView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            stackView.addArrangedSubview(partView)
        }

        let termsOfServiceView = TermsOfServiceView()
        termsOfServiceView.agreementState = self.agreementState
        stackView.addArrangedSubview(termsOfServiceView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
