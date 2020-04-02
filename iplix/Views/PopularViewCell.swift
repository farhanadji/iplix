//
//  PopularViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 02/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class PopularViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet var viewCollection: UICollectionView!
    
    var movies: [Movies] = []
    var genres: [Genres] = []
    var titleToSend: String = "title"
    var network = NetworkManager()
//    var delegate: UICollectionViewDelegate?
//    var datasource: UICollectionViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("popularViewCell called")
        self.viewCollection.dataSource = self
        self.viewCollection.delegate = self
        self.viewCollection.register(UINib.init(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        // Initialization code
        network.getPopularMovies() { response in
            self.movies = response
        }
        network.getGenres() { response in
            self.genres = response
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollectionView() -> Void {
        DispatchQueue.main.async {
            self.viewCollection.reloadData()
        }
    }
    
//    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow: Int) {
//        viewCollection.dataSource = dataSourceDelegate
//        viewCollection.delegate = dataSourceDelegate
//        viewCollection.tag = forRow
//        viewCollection.reloadData()
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(movies.count)
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        print(movies[indexPath.row].title!)
        cell.title.text = movies[indexPath.row].title!
        cell.image.image = nil
        if let poster = movies[indexPath.row].poster_path {
            cell.image.sd_setImage(with: URL(string: network.posterURL + poster))
        }
        if let genreId = movies[indexPath.row].genre_ids?.first {
            let genre = genres.filter({ $0.id == genreId })
            cell.genre.text = genre[0].name
        } else {
            cell.genre.text = " "
        }
       
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        titleToSend = movies[indexPath.row].title!
       // performSegue(withIdentifier:"goToDetail", sender: self)
    }
    
}
