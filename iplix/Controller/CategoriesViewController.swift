//
//  CategoriesViewController.swift
//  iplix
//
//  Created by Farhan Adji on 17/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    let network = NetworkManager()
    var genres: [Genres] = []
    var genre_id: Int?
    var genre_title: String?
    @IBOutlet weak var categoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        network.getGenres { response in
            self.genres = response
            self.categoryTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.identifier.goMoreFromCategory {
            let vc = segue.destination as? MorePageViewController
            vc?.sender = K.identifier.senderCategory
            vc?.genre_id = self.genre_id
            vc?.type = self.genre_title!
        }
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.category, for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.text = genres[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.genre_id = genres[indexPath.row].id
        self.genre_title = genres[indexPath.row].name
        performSegue(withIdentifier: K.identifier.goMoreFromCategory, sender: self)
    }
    
}
