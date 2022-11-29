//
//  MainFilterViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainFilterViewController: BaseViewController {
    
    //별점 설정
    @IBOutlet weak var starRateView: StarRatingView!
    
    //지역 설정
    @IBOutlet weak var locationUpdateButton: UIButton!
    @IBOutlet weak var segmentForRadius: UISegmentedControl!
    @IBOutlet weak var setRadiusView: UIView!
    @IBOutlet weak var locationHelpLabel: UILabel!
    
    //분야 설정
    @IBOutlet weak var fieldUpdateButton: UIButton!
    @IBOutlet weak var selectedFieldLabel: PaddingLabel!
    @IBOutlet weak var fieldHelpLabel: UILabel!
    
    //요일 설정
    @IBOutlet weak var dayBgView: UIView!
    @IBOutlet var dayButtons: [UIButton]!
    
    //시간 설정
    @IBOutlet weak var timeBgView: UIView!
    @IBOutlet var timeButtons: [UIButton]!
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Subject & Relay
    var selectedAddress: PublishSubject<KakaoRestAPIModel.AddressSearch.Document> = PublishSubject()
    var selectedFieldCategory: PublishSubject<[String]> = PublishSubject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureInit()
    }
    
    static func viewController() -> MainFilterViewController {
        let viewController = MainFilterViewController.viewController("Main")
        return viewController
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
}

//extension MainFilterViewController {
//
//    func bind(reactor: MainFilterReactor) {
//        //MARK: Bindable With Reactor
//        reactor.state
//            .map{ $0.neighborhoodCount }.debug("Neigborhood Count")
//            .withLatestFrom(selectedAddress) { ($0, $1) }
//            .map { ($0.1.addressName, $0.0) } // "\($0.1.addressName) - 주변 동네 \($0.0)개"
//            .bind(to: rx.setLocationLabel)
//            .disposed(by: disposeBag)
//
//        //MARK: Bindable With IBOutlet
//        locationUpdateButton.rx.tap
//            .subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//                let vieWController = SearchAddressViewController.viewController("Main")
//                vieWController.selectedAddress = self.selectedAddress
//                self.navigationController?.pushViewController(vieWController, animated: true)
//            }).disposed(by: disposeBag)
//
//        fieldUpdateButton.rx.tap
//            .subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//                let vieWController = SelectFieldViewController.viewController("Main")
//                vieWController.selectedFieldCategory = self.selectedFieldCategory
//                self.navigationController?.pushViewController(vieWController, animated: true)
//            }).disposed(by: disposeBag)
//
//        dayButtons.forEach { button in
//            button.rx.tap
//                .do(onNext: { [weak self] _ in
//                    self?.updateButtonShadow(isSelected: button.isSelected, sender: button)
//                }).subscribe { _ in
//                    DEBUG_LOG(button.currentTitle ?? "")
//                }.disposed(by: disposeBag)
//        }
//
//        timeButtons.forEach { button in
//            button.rx.tap
//                .do(onNext: { [weak self] _ in
//                    self?.updateButtonShadow(isSelected: button.isSelected, sender: button)
//                }).subscribe { _ in
//                    DEBUG_LOG(button.currentTitle ?? "")
//                }.disposed(by: disposeBag)
//        }
//
//        //MARK: Bindable With Subject
//        Observable.combineLatest(selectedAddress, segmentForRadius.rx.selectedSegmentIndex)
//            .debounce(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.asyncInstance)
//            .do(onNext: { [weak self] _ in
//                self?.setRadiusView.isHidden = false
//                //self?.locationHelpLabel.isHidden = true
//            })
//            .map { (data, index) -> MainFilterReactor.Action in
//                let radius = index == 3 ? "5000" : index == 2 ? "3000" : index == 1 ? "2000" : "1000"
//                return MainFilterReactor.Action.findNeighborhood(data: data, radius: radius)
//            }.bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        selectedFieldCategory
//            .map { $0.sorted() }
//            .subscribe(onNext: { [weak self] category in
//                let string = category.reduce("", { $0 + "\n" + $1 })
//                let attrString = NSMutableAttributedString(string: string)
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 4
//                attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//                self?.selectedFieldLabel.attributedText = attrString
//                self?.selectedFieldLabel.isHidden = false
//            }).disposed(by: disposeBag)
//
//    }
//
//}
//
//extension MainFilterViewController {
//    private func configureInit() {
//        self.reactor = MainFilterReactor()
//
//        dayBgView.layer.cornerRadius = 5
//        dayButtons.forEach {
//            $0.layer.cornerRadius = 5
//            $0.isSelected = false
//        }
//        timeBgView.layer.cornerRadius = 5
//        timeButtons.forEach {
//            $0.layer.cornerRadius = 5
//            $0.isSelected = false
//        }
//        selectedFieldLabel.isHidden = true
//        setRadiusView.isHidden = true
//    }
//
//    private func updateButtonShadow(isSelected: Bool, sender: UIButton) {
//        DispatchQueue.main.async {
//            sender.isSelected = !sender.isSelected
//            sender.backgroundColor = sender.isSelected ? UIColor(named:"WhiteNGray") : UIColor(named: "systemGray6")
//            let fontWeight:UIFont.Weight = sender.isSelected ? .semibold : .medium
//            sender.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: fontWeight)
//            sender.layer.shadowOpacity = sender.isSelected ? 1.0 : 0.0
//            sender.layer.shadowColor = UIColor(named: "systemGray3")?.cgColor
//            sender.layer.shadowOffset = CGSize(width: 1, height: 1)
//            sender.layer.shadowRadius = 2
//        }
//
//    }
//
//}
//
//extension Reactive where Base: MainFilterViewController {
//
//    var setLocationLabel: Binder<(String, Int)> {
//        return Binder(base) { viewController, addressInfo in
//            let addr = addressInfo.0 == "" ? "지역을 설정해주세요." : "\(addressInfo.0) - 주변 동네 \(addressInfo.1)개"
//            let color: UIColor = addressInfo.0 == "" ? .lightGray : .black
//            let font: UIFont = addressInfo.0 == "" ? .systemFont(ofSize: 12) : .systemFont(ofSize: 14, weight: .semibold)
//            viewController.locationHelpLabel.text = addr
//            viewController.locationHelpLabel.textColor = color
//            viewController.locationHelpLabel.font = font
//        }
//    }
//
//}
