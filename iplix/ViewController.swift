//
//  ViewController.swift
//  iplix
//
//  Created by Farhan Adji on 01/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var accountBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PopularViewCell", bundle: nil), forCellReuseIdentifier: "popularCell")
        
    }
    
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToDetail" {
            let vc = segue.destination as! DetailViewController
            vc.judul = titleToSend
        }
    }
 */
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            print("1")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! PopularViewCell
            return cell
        }
        else{
            print("2")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
}


