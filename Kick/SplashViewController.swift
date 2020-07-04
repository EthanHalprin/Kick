//
//  SplashViewController.swift
//  Kick
//
//  Created by Ethan on 13/06/2020.
//  Copyright © 2020 Ethan Halprin©. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

