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
    
    @IBOutlet weak var detailCollection: UICollectionView!
    
    var movies: [Movie] = []
    var genres: [Genres] = []
    var network = NetworkManager()
    var delegate: ViewCellDelegator!
    var type: String = ""
    var movieToSend: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailCollection.dataSource = self
        detailCollection.delegate = self
        detailCollection.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        // Do any additional setup after loading the view.
        
        if type == "popular" {
            navigationItem.title = "Popular Movies"
        } else if type == "now_playing" {
            navigationItem.title = "Now Playing"
        }
        network.getGenres() { response in
            self.genres = response
            DispatchQueue.main.async {
                if self.movies.count > 0 {
                    self.detailCollection.reloadData()
                }
            }
        }
        network.getMovies(typeMovie: type) { response in
            self.movies = response
            DispatchQueue.main.async {
                if self.genres.count > 0 {
                    self.detailCollection.reloadData()
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

extension MorePageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        if let title = cell.title {
            title.text = movies[indexPath.row].title!
        }
        if let image = cell.poster {
            image.image = nil
            if let poster = movies[indexPath.row].poster_path {
                image.sd_setImage(with: URL(string: network.posterURL + poster))
            }
        }
        
        if let genreLabel = cell.genre {
            if let genreId = movies[indexPath.row].genre_ids?.first {
                let genre = genres.filter({ $0.id == genreId })
                genreLabel.text = genre[0].name
            } else {
                genreLabel.text = " "
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieToSend = movies[indexPath.row]
        performSegue(withIdentifier: "goToDetailFromAll", sender: self)
    }
    
    
}
