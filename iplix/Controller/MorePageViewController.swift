//
//  MorePageViewController.swift
//  iplix
//
//  Created by Farhan Adji on 05/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD

class MorePageViewController: UIViewController {
    
    @IBOutlet weak var movieList: UITableView!
    
    var movies: [Movie] = []
    var genres: [Genres] = []
    var network = NetworkManager()
    var delegate: ViewCellDelegator!
    var type: String = ""
    var sender: String = ""
    var genre_id: Int?
    var movieToSend: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        movieList.dataSource = self
        movieList.delegate = self
        movieList.register(UINib(nibName: K.nib.movietableview,
                                 bundle: nil),
                           forCellReuseIdentifier: K.identifier.movietable)
        
        if type == K.typeMovie.popular {
            navigationItem.title = K.text.popular_movies
        } else if type == K.typeMovie.now_playing {
            navigationItem.title = K.text.now_playing
        } else if type == K.typeMovie.upcoming {
            navigationItem.title = K.text.upcoming
        } else if type == K.typeMovie.top_rated {
            navigationItem.title = K.text.top_rated
        } else {
            navigationItem.title = type
        }
        
        if sender == K.identifier.senderHome {
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
                        hud.dismiss(afterDelay: 2.0)
                    }
                }
            }
        } else if sender == K.identifier.senderCategory {
            if let id = genre_id {
                network.getDiscoverGenre(id: String(id)) { response in
                    self.movies = response
                    DispatchQueue.main.async {
                        if self.movies.count > 0 {
                            self.movieList.reloadData()
                            hud.dismiss(afterDelay: 1.0)
                        }
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.identifier.goDetailFromAll {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.movietable, for: indexPath) as! MovieTableViewCell
        cell.indexLabel.text = String(indexPath.row + 1)
        cell.posterImage.sd_setImage(with: URL(string: network.posterURL + movies[indexPath.row].poster_path!))
        cell.titleLabel.text = movies[indexPath.row].title
        if sender == K.identifier.senderHome {
            if let genreId = movies[indexPath.row].genre_ids?.first {
                let genre = genres.filter({ $0.id == genreId })
                cell.genreLabel.text = genre[0].name
            }
        } else {
            cell.genreLabel.text = " "
        }
        cell.releaseDate.text = movies[indexPath.row].release_date
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieToSend = movies[indexPath.row]
        performSegue(withIdentifier: K.identifier.goDetailFromAll, sender: self)
    }
}
