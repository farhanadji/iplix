//
//  FavoriteViewController.swift
//  iplix
//
//  Created by Farhan Adji on 14/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    let db = Firestore.firestore()
    var favoriteMovies: [Movie] = []
    var movieToSend: Movie?
    var genres: [Genres] = []
    let network = NetworkManager()
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteMovies = []
        var favorites = db.collection("favorites").whereField("user", isEqualTo: Auth.auth().currentUser?.email)
        favorites.addSnapshotListener { (snapshot, error) in
            self.favoriteMovies = []
            if let snapshotDocuments = snapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()
                    print(data["movie"]!)
                    if let movie = data["movie"] as? [String: Any]{
                        self.favoriteMovies.append(self.parseData(movieData: movie))
                    }
                }
            }
            self.favoriteTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        
        network.getGenres() { response in
            self.genres = response
            DispatchQueue.main.async {
                if self.favoriteMovies.count > 0 {
                    self.favoriteTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailFromFavorite" {
            let vc = segue.destination as? MovieDetailViewController
            vc?.movieData = movieToSend
        }
    }
    
    func parseData(movieData: [String: Any]) -> Movie {
        let backdrop_path = movieData["backdrop_path"] as? String
        let genre_ids = movieData["genre_ids"] as? [Int]
        let id = movieData["id"] as? Int
        let overview = movieData["overview"] as? String
        let popularity = movieData["popularity"] as? Double
        let poster_path = movieData["poster_path"] as? String
        let release_date = movieData["release_date"] as? String
        let title = movieData["title"] as? String
        let vote_average = movieData["vote_average"] as? Double
        let vote_count = movieData["vote_count"] as? Int
        
        
        let movie = Movie(popularity: popularity, vote_count: vote_count, poster_path: poster_path, id: id, backdrop_path: backdrop_path, title: title, genre_ids: genre_ids, overview: overview, release_date: release_date, vote_average: vote_average)
        
        return movie
    }
    
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if let poster = favoriteMovies[indexPath.row].poster_path {
            cell.poster.sd_setImage(with: URL(string: network.posterURL + poster))
        }
        if let title = favoriteMovies[indexPath.row].title {
            cell.titleLabel.text = title
        }
        
        if let genreId = favoriteMovies[indexPath.row].genre_ids?.first {
            let genre = genres.filter({ $0.id == genreId })
            cell.genreLabel.text = genre[0].name
        } else {
            cell.genreLabel.text = " "
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieToSend = favoriteMovies[indexPath.row]
        performSegue(withIdentifier: "goToDetailFromFavorite", sender: self)
    }
}
