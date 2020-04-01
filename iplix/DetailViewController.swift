//
//  DetailViewController.swift
//  iplix
//
//  Created by Farhan Adji on 01/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var judul: String?
    
    @IBOutlet weak var judulLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        judulLabel.text = judul
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
