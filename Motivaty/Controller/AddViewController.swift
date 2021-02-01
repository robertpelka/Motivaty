//
//  AddViewController.swift
//  Motivaty
//
//  Created by Robert Pelka on 01/02/2021.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = addButton.frame.size.height/2
    }

}
