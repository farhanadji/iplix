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
import Firebase

class MorePageViewController: UIViewController {
    
    //    @IBOutlet weak var movieList: UITableView!
    
    let movieList = UITableView()
    var moviesHasRating: [Movie] = []
    var movies: [Movie] = []
    var genres: [Genres] = []
    var network = NetworkManager()
    var delegate: ViewCellDelegator!
    var type: String = ""
    var sender: String = ""
    var filter = "popularity.desc"
    var index = 1
    var genre_id: Int?
    var total_pages: Int?
    var movieToSend: Movie?
    var ratings: [Ratings] = []
    var movieRatingId: [Int] = []
    let filterBtn = UIBarButtonItem()
    let sheetView = BottomSheetView.instance
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationController()
        setupBottomSheetView()
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
            filterBtn.isEnabled = false
            network.getGenres() { response in
                self.genres = response
                DispatchQueue.main.async {
                    if self.movies.count > 0 {
                        self.movieList.reloadData()
                    }
                }
            }
            network.getMovies(typeMovie: type) { response, pages in
                self.movies = response
                self.total_pages = pages
                DispatchQueue.main.async {
                    if self.movies.count > 0 {
                        self.movieList.reloadData()
                        hud.dismiss(afterDelay: 2.0)
                    }
                }
            }
        } else if sender == K.identifier.senderCategory {
            filterBtn.isEnabled = true
            if let id = genre_id {
                network.getDiscoverGenre(id: String(id)) { response, pages in
                    self.movies = response
                    self.total_pages = pages
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
    
    func setupTableView() {
        view.addSubview(movieList)
        movieList.rowHeight = 100
        movieList.translatesAutoresizingMaskIntoConstraints = false
        movieList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        movieList.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        movieList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        movieList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupNavigationController() {
        filterBtn.target = self
        filterBtn.image = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
        filterBtn.action = #selector(bottomSheetView)
        navigationItem.rightBarButtonItem = filterBtn
    }
    
    func setupBottomSheetView() {
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        sheetView.dimBackground.addGestureRecognizer(dismissTap)
    }
    
    @objc func bottomSheetView() {
        //        sheetView.show()
        let filterVC = FilterViewController()
        filterVC.modalPresentationStyle = .fullScreen
        filterVC.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            filterVC.backgroundImage = self.navigationController?.view.asImage()
            self.present(filterVC, animated: false, completion: nil)
        }
        
    }
    
    @objc func dismissTapped() {
        print("dismiss clicked")
        sheetView.dismiss()
    }
    
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == K.identifier.goDetailFromAll {
    //            if let vc = segue.destination as? MovieDetailViewController {
    //                vc.movieData = movieToSend
    //            }
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ratings = db.collection(K.collection.ratings).addSnapshotListener { (snapshot, error) in
            self.ratings = []
            self.movieRatingId = []
            if let snapshotDocuments = snapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()
                    self.movieRatingId.append(data["movie_id"] as! Int)
                    self.ratings.append(Helper.parseDataRating(ratingData: data))
                }
            }
            self.movieList.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FilterViewController.resetSelected()
    }
}


extension MorePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.movietable, for: indexPath) as! MovieTableViewCell
        if movieRatingId.contains(movies[indexPath.row].id!){
            let rating = ratings.filter {
                $0.movie_id == movies[indexPath.row].id
            }.first
            cell.stars.rating = rating?.rating_average! as! Double
            cell.stars.text = "(\(rating?.rating_count! ?? 0))"
        } else {
            cell.stars.rating = 0
            cell.stars.text = "(0)"
        }
        
        cell.indexLabel.text = String(indexPath.row + 1)
        if let poster = movies[indexPath.row].poster_path {
            cell.posterImage.sd_setImage(with: URL(string: network.posterURL + poster))
        }
        cell.titleLabel.text = movies[indexPath.row].title
        if sender == K.identifier.senderHome {
            if let genreId = movies[indexPath.row].genre_ids?.first {
                let genre = genres.filter({ $0.id == genreId })
                cell.genreLabel.text = genre[0].name
            }
        } else {
            cell.genreLabel.text = " "
        }
        
        if let date = movies[indexPath.row].release_date {
            cell.releaseDate.text = Helper.humanizeDate(date: date)
        } else {
            cell.releaseDate.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        if indexPath.row == movies.count - 1 {
            hud.show(in: self.view)
            if index < total_pages! {
                index = index + 1
                if sender == K.identifier.senderHome {
                    network.getMovies(typeMovie: type, page: index) { response, pages in
                        self.movies.append(contentsOf: response)
                        self.movieList.reloadData()
                        hud.dismiss(afterDelay: 0.5)
                    }
                } else if sender == K.identifier.senderCategory {
                    if let id = genre_id {
                        network.getDiscoverGenre(id: String(id), page: index, filter: filter) { response, pages in
                            self.movies.append(contentsOf: response)
                            self.movieList.reloadData()
                            hud.dismiss(afterDelay: 0.5)
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        movieToSend = movies[indexPath.row]
        //        performSegue(withIdentifier: K.identifier.goDetailFromAll, sender: self)
        let detailVC = MovieDetailViewController()
        detailVC.movieData = movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MorePageViewController: FilterDelegate {
    func filterData(selected: FilterViewController.Filtering) {
        print("called")
        let hud = JGProgressHUD(style: .dark)
         hud.textLabel.text = "Loading"
         hud.show(in: self.view)
             
        
        switch selected {
        case .popularity:
            filter = "popularity.desc"
        case .release:
            filter = "release_date.desc"
        case .revenue:
            filter = "revenue.desc"
        case .title:
            filter = "original_title.asc"
        }
        
        if let id = genre_id {
            network.getDiscoverGenre(id: String(id), filter: filter) { response, pages in
                self.movies = response
                self.total_pages = pages
                DispatchQueue.main.async {
                    self.movieList.reloadData()
                    hud.dismiss(afterDelay: 1.0)
                }
            }
        }
    }
    
    
}
