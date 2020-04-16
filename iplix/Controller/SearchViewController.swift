//
//  SearchViewController.swift
//  iplix
//
//  Created by Farhan Adji on 09/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    let network: NetworkManager = NetworkManager()
    @IBOutlet weak var searchBar: UISearchBar!
    var movies: [Movie] = []
    var genres: [Genres] = []
    var movieToSend: Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        searchBar.showsCancelButton = false
        network.getGenres() { response in
            self.genres = response
            DispatchQueue.main.async {
                if self.movies.count > 0 {
                    self.searchTableView.reloadData()
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailFromSearch" {
            let vc = segue.destination as! MovieDetailViewController
            vc.movieData = movieToSend
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if let poster = movies[indexPath.row].poster_path {
            cell.poster.sd_setImage(with: URL(string: network.posterURL + poster))
        }
        if let title = movies[indexPath.row].title {
            cell.titleLabel.text = title
        }
        
        if let genreId = movies[indexPath.row].genre_ids?.first {
            let genre = genres.filter({ $0.id == genreId })
            cell.genreLabel.text = genre[0].name
        } else {
            cell.genreLabel.text = " "
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieToSend = movies[indexPath.row]
        performSegue(withIdentifier: "goToDetailFromSearch", sender: self)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if searchBar.text! == "" {
            movies.removeAll()
            self.searchTableView.reloadData()
        } else {
            network.searchMovie(query: searchBar.text!) { response in
                self.movies = response
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            }
        }
        
    }
}
