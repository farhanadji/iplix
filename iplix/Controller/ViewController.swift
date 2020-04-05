//
//  ViewController.swift
//  iplix
//
//  Created by Farhan Adji on 01/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var accountBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var movieToSend: Movie?
    var type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PopularViewCell", bundle: nil), forCellReuseIdentifier: "popularCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToDetail" {
            if let vc = segue.destination as? MovieDetailViewController {
                if let movieData = movieToSend {
                    vc.movieData = movieData
                }
            }
        }
        
        if segue.identifier == "goToAll" {
            if let vc = segue.destination as? MorePageViewController {
                vc.type = type
            }
        }
    }
 
    @IBAction func accountBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier:"goToAccount", sender: self)
    }
    
}

//MARK: - UITableView

extension ViewController: UITableViewDataSource, UITableViewDelegate, ViewCellDelegator {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell",for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = "Popular"
            cell.loadAPI(typeMovie: "popular")
            cell.delegate = self
            cell.type = "popular"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = "Now Playing"
            cell.loadAPI(typeMovie: "now_playing")
            cell.delegate = self
            cell.type = "now_playing"
            return cell
            
        }
    }
    
    func gotoDetail(movie: Movie) {
        movieToSend = movie
        performSegue(withIdentifier:"goToDetail", sender: self)
    }
    
    func goToAll(type: String) {
        self.type = type
        performSegue(withIdentifier: "goToAll", sender: self)
     }
}


