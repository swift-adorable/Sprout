//
//  UserProfileViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserProfileViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var pageContainerView: UIView!
    
    fileprivate lazy var scrollingMenuView = ScrollingMenuView()
    
    fileprivate lazy var pageViewController = UIPageViewController()
    fileprivate(set) lazy var pages: [UIViewController] = {
        return [UserProfileAboutViewController.viewController("Follow"),
                SelectFieldViewController.viewController("Main"),
                SearchAddressViewController.viewController("Main"),
                SelectFieldViewController.viewController("Main")]
    }()
    
    var currentIndex: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    private var isTappedMenu: Bool = false
    
    private let imageMinHeight: CGFloat = 38
    private var imageMaxHeight: CGFloat = APP_HEIGHT() * 0.3
    private var latestContentOffSet: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInit()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollingMenuView.frame = menuContainerView.bounds
        pageViewController.view.frame = pageContainerView.bounds
    }
    


}

extension UserProfileViewController {
    
    private func bind() {
        
        currentIndex
            .subscribe(onNext: { [weak self] (index) in
                guard let `self` = self else {return}
                
                self.scrollingMenuView.changeTextColorAtIndex(selectedIndex: index)
                self.scrollingMenuView.changeScrollBarOffset(with: nil, currentIndex: index)
                self.scrollingMenuView.changeScrollPosition(self.scrollingMenuView.getLabelFrame(index))
                
                if var firstViewController = self.pageViewController.viewControllers?.first,
                   let currentIndex = self.pages.firstIndex(of: firstViewController) {
                    
                    if index != currentIndex {
                        guard self.pages.count > index else {return}
                        var direction : UIPageViewController.NavigationDirection = .reverse
                        if index > currentIndex { direction = .forward }
                        firstViewController = self.pages[index]
                        self.pageViewController.setViewControllers([firstViewController],
                                                                   direction: direction,
                                                                   animated: true,
                                                                   completion: nil)
                    }
                }
            }).disposed(by: disposeBag)
        
        scrollContentOffset
            .asDriver(onErrorJustReturn: .zero)
            .drive(onNext: { [weak self] (offset) in
                guard let `self` = self else { return }
                
                if self.latestContentOffSet.x != offset.x && self.latestContentOffSet.x != APP_WIDTH() {
                    if !self.isTappedMenu {
                        let index = self.currentIndex.value
                        self.scrollingMenuView.changeScrollBarOffset(with: offset, currentIndex: index)
                    }

                } else if self.latestContentOffSet.y != offset.y {
                    var height = self.profileImageViewHeight.constant - offset.y
                    
                    if height < self.imageMinHeight {
                        height = self.imageMinHeight
                        
                    } else if height > self.imageMaxHeight * 1.4 {
                        height = self.imageMaxHeight * 1.4
                    }
                    
                    self.profileImageViewHeight.constant = height
                }
                
                self.latestContentOffSet = offset
                
            }).disposed(by: disposeBag)
        
        scrollIsEndDrag
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] isEndDrag in
                guard let `self` = self else { return }
                if isEndDrag {
                    if self.profileImageViewHeight.constant >= self.imageMaxHeight * 1.2 {
                        self.profileImageViewHeight.constant = self.imageMaxHeight
                        self.profileImageView.setNeedsUpdateConstraints()
                        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7,
                                       initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                    }
                } else {
                    self.isTappedMenu = false
                }
            }).disposed(by: disposeBag)
    }
}

extension UserProfileViewController {
    
    private func configureInit() {
        
        App.api.randomWord(nums: 1) { [weak self] keyword in
            guard let `self` = self else { return }
            if let url = keyword.first?.randomImageURL {
                self.profileImageView.kf.setImage(with: url, completionHandler: { result in //[weak self] result in
    //                guard let `self` = self else { return }
                    switch result {
                    case .success(let value):
                        //let ratio = value.image.size.width / value.image.size.height
                        let imageSize = value.image.size
                        let ratioHeight = APP_WIDTH() * imageSize.height / imageSize.width
                        self.imageMaxHeight = min(self.imageMaxHeight, ratioHeight)
                    
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
        }
        
        profileImageViewHeight.constant = imageMaxHeight
        
        setMenuView()
        setPageView()
        
    }
    
    private func setMenuView() {
    
        let titles: [String] = ["About", "Follow", "Post", "License"]
                        
        scrollingMenuView = ScrollingMenuView(frame: menuContainerView.bounds)
        scrollingMenuView.delegate = self

        scrollingMenuView.setTitles(titles: titles)
        menuContainerView.addSubview(scrollingMenuView)
        scrollingMenuView.changeTextColorAtIndex(selectedIndex: 0)
    }
    
    private func setPageView() {

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if var firstViewController = pages.first {
            firstViewController = pages[0]
            self.pageViewController.setViewControllers([firstViewController], direction: .reverse, animated: false, completion: nil)
        }
        
        for page in pages {
            if let page = page as? BaseViewController {
                page.scrollContentOffset = self.scrollContentOffset
                page.scrollIsEndDrag = self.scrollIsEndDrag
            }
        }
        
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
        self.addChild(pageViewController)
        pageContainerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        self.view.layoutIfNeeded()
    }
    
    
}

extension UserProfileViewController: ScrollingMenuViewDelegate {
    func selectedIndexWithMenuView(_ view: ScrollingMenuView, index: Int) {
        self.currentIndex.accept(index)
        self.isTappedMenu = true
    }
    
    func changeScrollPosition(_ frame : CGRect) {
        
        var offsetX = frame.origin.x - ((APP_WIDTH()-frame.size.width)/2)
        let offsetWidth = scrollingMenuView.scrollView.contentSize.width - offsetX
        
        if offsetX < 0 { offsetX = 0 }
        
        if (offsetWidth - scrollingMenuView.scrollView.frame.size.width) < 0 {
            offsetX = scrollingMenuView.scrollView.contentSize.width - scrollingMenuView.scrollView.frame.size.width
        }
        
        scrollingMenuView.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    
}


//MARK: - PageViewController Delegate, DataSource
extension UserProfileViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed == true {
            if let firstViewController = pageViewController.viewControllers?.first,
                let index = pages.firstIndex(of: firstViewController){
                self.currentIndex.accept(index)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {return nil}
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {return pages.last}
        guard pages.count > previousIndex else {return nil}

        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {return nil}
        
        let nextIndex = viewControllerIndex + 1
        let pagesCount = pages.count
        
        guard pagesCount != nextIndex else {return pages.first}
        guard pagesCount > nextIndex else {return nil}

        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstViewController = pageViewController.viewControllers?.first,
            let firstViewControllerIndex = pages.firstIndex(of: firstViewController) else {return 0}
        return firstViewControllerIndex
    }
}

extension UserProfileViewController: PanModalPresentable {

     override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
     }

     var panScrollable: UIScrollView? {
         return nil
     }

     var anchorModalToLongForm: Bool {
          return false
     }
}
