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
        var favorites = db
            .collection(K.collection.favorites)
            .whereField(K.favorites_attr.user, isEqualTo: Auth.auth().currentUser?.email)
        favorites.addSnapshotListener { (snapshot, error) in
            self.favoriteMovies = []
            if let snapshotDocuments = snapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()
                    if let movie = data[K.favorites_attr.movie] as? [String: Any]{
                        self.favoriteMovies.append(Helper.parseDataMovie(movieData: movie))
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
        favoriteTableView.register(UINib(nibName: K.nib.searchtableview,
                                         bundle: nil),
                                   forCellReuseIdentifier: K.identifier.search)
        
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
        if segue.identifier == K.identifier.goDetailFromFavorite {
            let vc = segue.destination as? MovieDetailViewController
            vc?.movieData = movieToSend
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: K.identifier.search, for: indexPath) as! SearchTableViewCell
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
        performSegue(withIdentifier: K.identifier.goDetailFromFavorite, sender: self)
    }
}
