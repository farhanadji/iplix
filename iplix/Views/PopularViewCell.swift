//
//  PopularViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 02/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage

protocol ViewCellDelegator {
    func gotoDetail(movie: Movie)
    func goToAll(type: String)
}

class PopularViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var viewCollection: UICollectionView!
    @IBOutlet weak var seeAllBtn: UIButton!
    
    var movies: [Movie] = []
    var genres: [Genres] = []
    var network = NetworkManager()
    var delegate: ViewCellDelegator!
    var type: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewCollection.dataSource = self
        viewCollection.delegate = self
        viewCollection.register(UINib(nibName: K.nib.movieview, bundle: nil), forCellWithReuseIdentifier: K.identifier.movie)
    }
    
    func loadAPI(typeMovie: String){
        
        network.getGenres() { response in
            self.genres = response
            DispatchQueue.main.async {
                if self.movies.count > 0 {
                    self.viewCollection.reloadData()
                }
            }
        }
        network.getMovies(typeMovie: typeMovie) { response in
            self.movies = response
            DispatchQueue.main.async {
                if self.genres.count > 0 {
                    self.viewCollection.reloadData()
                }
            }
        }
        
    }
    @IBAction func buttonClicked(_ sender: UIButton) {
        if sender == seeAllBtn {
            goToAll(type: type)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func goToAll(type: String) {
        delegate.goToAll(type: type)
    }
}

//MARK: - UICollectionView
extension PopularViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.identifier.movie, for: indexPath) as! MovieCollectionViewCell
        
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
        let getMovie = movies[indexPath.row]
        delegate.gotoDetail(movie: getMovie)
    }
}

