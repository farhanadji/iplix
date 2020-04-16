//
//  MorePageViewController.swift
//  iplix
//
//  Created by Farhan Adji on 05/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage

class MorePageViewController: UIViewController {
    
//    @IBOutlet weak var detailCollection: UICollectionView!
    @IBOutlet weak var movieList: UITableView!
    
    var movies: [Movie] = []
    var genres: [Genres] = []
    var network = NetworkManager()
    var delegate: ViewCellDelegator!
    var type: String = ""
    var movieToSend: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieList.dataSource = self
        movieList.delegate = self
        movieList.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieListCell")
        
        if type == "popular" {
            navigationItem.title = "Popular Movies"
        } else if type == "now_playing" {
            navigationItem.title = "Now Playing"
        }
        network.getGenres() { response in
            self.genres = response
            DispatchQueue.main.async {
                if self.movies.count > 0 {
                    self.movieList.reloadData()
                }
            }
        }
        network.getMovies(typeMovie: type) { response in
            self.movies = response
            DispatchQueue.main.async {
                if self.genres.count > 0 {
                    self.movieList.reloadData()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailFromAll" {
            if let vc = segue.destination as? MovieDetailViewController {
                vc.movieData = movieToSend
            }
        }
    }
}


extension MorePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath) as! MovieTableViewCell
        cell.indexLabel.text = String(indexPath.row + 1)
        cell.posterImage.sd_setImage(with: URL(string: network.posterURL + movies[indexPath.row].poster_path!))
        cell.titleLabel.text = movies[indexPath.row].title
         if let genreId = movies[indexPath.row].genre_ids?.first {
            let genre = genres.filter({ $0.id == genreId })
            cell.genreLabel.text = genre[0].name
        } else {
            cell.genreLabel.text = " "
        }
        cell.releaseDate.text = movies[indexPath.row].release_date
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieToSend = movies[indexPath.row]
        performSegue(withIdentifier: "goToDetailFromAll", sender: self)
    }
}
