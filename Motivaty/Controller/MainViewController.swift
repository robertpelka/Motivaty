//
//  MainViewController.swift
//  Motivaty
//
//  Created by Robert Pelka on 30/01/2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }


}

