//
//  SearchViewController.swift
//  iplix
//
//  Created by Farhan Adji on 09/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD

class SearchViewController: UIViewController {
    
    //    @IBOutlet weak var searchTableView: UITableView!
    let network: NetworkManager = NetworkManager()
    //    @IBOutlet weak var searchBar: UISearchBar!
    let searchTableView = UITableView()
    let menuBtn = UIBarButtonItem()
    let searchBar = UISearchBar()
    let menuView = HamburgerMenu.instance
    var movies: [Movie] = []
    var genres: [Genres] = []
    var movieToSend: Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupGesture()
        setupNavigationController()
        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: K.nib.searchtableview,
                                       bundle: nil),
                                 forCellReuseIdentifier: K.identifier.search)
        searchTableView.tableFooterView = UIView(frame: CGRect.zero)
        searchBar.showsCancelButton = false
        network.getGenres() { response in
            self.genres = response
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
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
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == K.identifier.goDetailFromSearch {
    //            let vc = segue.destination as! MovieDetailViewController
    //            vc.movieData = movieToSend
    //        }
    //    }
    
    func setupSearchBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        searchBar.placeholder = "Search movie.."
        searchBar.isTranslucent = true
        searchBar.contentMode = .redraw
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        searchBar.bottomAnchor.constraint(equalTo: searchTableView.topAnchor, constant: 0).isActive = true
    }
    
    func setupTableView() {
        view.addSubview(searchTableView)
        searchTableView.rowHeight = 100
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        menuBtn.target = self
        menuBtn.image = UIImage(systemName: "list.dash")
        menuBtn.action = #selector(menuTapped)
        navigationItem.leftBarButtonItem = menuBtn
        tabBarController?.tabBar.isHidden = true
    }
    
    func setupGesture() {
         let edgeLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(menuTapped))
         edgeLeft.edges = .left
         view.addGestureRecognizer(edgeLeft)
     }
    
    @objc func menuTapped() {
         menuView.showMenu()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.search, for: indexPath) as! SearchTableViewCell
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
        let detailVC = MovieDetailViewController()
        detailVC.movieData = movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
        //        movieToSend = movies[indexPath.row]
        //        performSegue(withIdentifier: K.identifier.goDetailFromSearch, sender: self)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if searchBar.text! == "" {
            movies.removeAll()
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
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
