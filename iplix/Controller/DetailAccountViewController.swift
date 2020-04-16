//
//  DetailAccountViewController.swift
//  iplix
//
//  Created by Farhan Adji on 13/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class DetailAccountViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    var name: String?
    var email: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = name
        subtitleLabel.text = email
    }
}
