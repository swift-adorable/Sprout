//
//  TabBarController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    @IBOutlet weak var mainTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarAttributes()
        
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let viewContoller = SelectLoginViewController.viewController(true).wrapViewController
            viewContoller.modalPresentationStyle = .fullScreen
            self.present(viewContoller, animated: true, completion: nil)
        }
        
    }
    
    // Tab Bar Item Select Animation
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }

        let timeInterval: TimeInterval = 0.35
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
          barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
    
}

extension TabBarController {
    
    private func configureTabBarAttributes() {
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .systemBackground
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            
            setTabBarItemColors(appearance.stackedLayoutAppearance)
            setTabBarItemColors(appearance.inlineLayoutAppearance)
            setTabBarItemColors(appearance.compactInlineLayoutAppearance)
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            
        } else {
            let signatureTheme: UIColor = .signature
            UITabBar.appearance().tintColor = signatureTheme
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : signatureTheme], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : signatureTheme], for: .selected)
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
        }
        
        
        
    }
    
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        let signatureTheme: UIColor = .signature
        
        itemAppearance.normal.iconColor = signatureTheme
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: signatureTheme]
        
        itemAppearance.selected.iconColor = signatureTheme
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: signatureTheme]
        
    }
}
