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
    
    @IBOutlet weak var sliderCollection: UICollectionView!
    @IBOutlet weak var accountBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var movieToSend: Movie?
    var type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView
            .register(
                UINib(nibName: K.nib.popularview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.popular)
        tableView
            .register(
                UINib(nibName: K.nib.sliderview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.sliderTable)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = K.text.back
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == K.identifier.goDetailFromHome {
            if let vc = segue.destination as? MovieDetailViewController {
                if let movieData = movieToSend {
                    vc.movieData = movieData
                }
            }
        }
        
        if segue.identifier == K.identifier.goAllFromHome {
            if let vc = segue.destination as? MorePageViewController {
                vc.type = type
                vc.sender = K.identifier.senderHome
            }
        }
    }
    
    @IBAction func accountBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.identifier.goAccount, sender: self)
    }
    
}

//MARK: - UITableView
extension ViewController: UITableViewDataSource, UITableViewDelegate, ViewCellDelegator {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.sliderTable, for: indexPath) as! SlideViewCell
            print(cell.frame.height)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular,for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.popular
            cell.loadAPI(typeMovie: K.typeMovie.popular)
            cell.delegate = self
            cell.type = K.typeMovie.popular
            print(tableView.frame.height)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular, for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.now_playing
            cell.loadAPI(typeMovie: K.typeMovie.now_playing)
            cell.delegate = self
            cell.type = K.typeMovie.now_playing
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular, for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.upcoming
            cell.loadAPI(typeMovie: K.typeMovie.upcoming)
            cell.delegate = self
            cell.type = K.typeMovie.upcoming
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular, for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.top_rated
            cell.loadAPI(typeMovie: K.typeMovie.top_rated)
            cell.delegate = self
            cell.type = K.typeMovie.top_rated
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = CGFloat()
        if indexPath.row == 0 {
            height = CGFloat(K.size.sliderHeight)
        } else {
            height = CGFloat(K.size.movieCollectionHeight)
        }
        return height
    }
    
    func gotoDetail(movie: Movie) {
        movieToSend = movie
        performSegue(withIdentifier: K.identifier.goDetailFromHome, sender: self)
    }
    
    func goToAll(type: String) {
        self.type = type
        performSegue(withIdentifier: K.identifier.goAllFromHome, sender: self)
    }
    
    
}


