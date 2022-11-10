//
//  SelectUserTypeViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit

class SelectUserTypeViewController: BaseViewController {

    @IBOutlet weak var mentorButton: UIButton!
    @IBOutlet weak var menteeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
