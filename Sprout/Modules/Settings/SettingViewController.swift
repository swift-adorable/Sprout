//
//  SettingViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTest(_ sender: Any) {
        let viewContoller = SelectLoginViewController.viewController(false).wrapViewController
        viewContoller.modalPresentationStyle = .fullScreen
        self.present(viewContoller, animated: true, completion: nil)
    }
    
}
