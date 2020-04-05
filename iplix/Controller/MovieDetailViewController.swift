//
//  MovieDetailViewController.swift
//  iplix
//
//  Created by Farhan Adji on 04/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var tableDetail: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    
    var movieData: Movie?
    var movieToSend: Movie?
    let network: NetworkManager = NetworkManager()
    var tableSection: Int = 2
    var cellSize: CGFloat = 320
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableDetail.delegate = self
        tableDetail.dataSource = self
        tableDetail.register(UINib(nibName: "RatingTableViewCell", bundle: nil), forCellReuseIdentifier: "ratingCell")
        tableDetail.register(UINib(nibName: "AddReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "addReviewCell")
        tableDetail.register(UINib(nibName: "PopularViewCell", bundle: nil), forCellReuseIdentifier: "popularCell")
        segmentControl.selectedSegmentIndex = 0
        if let data = movieData {
            if let backdropImage = data.backdrop_path {
                backdrop.sd_setImage(with: URL(string: network.posterURL + backdropImage))
            } else {
                backdrop.isHidden = true
            }
            imagePoster.sd_setImage(with: URL(string: network.posterURL + data.poster_path!))
            titleMovie.text = data.title!
        }
    }
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            tableSection = 2
            tableDetail.reloadData()
        case 1:
            tableSection = 2
            tableDetail.reloadData()
        case 2:
            print("3 called")
            tableSection = 2
            tableDetail.reloadData()
        default:
            tableSection = 1
            print("default")
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        if sender == shareBtn {
            var text: String = ""
            if let movie = movieData{
                text = "\(movie.title ?? "") - \(network.moviePageURL)\(movie.id ?? 0)"
            }
            let shareViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            shareViewController.popoverPresentationController?.sourceView = self.view
            self.present(shareViewController, animated: true, completion: nil)
        }
    }
}

//MARK: - TableView Contents Section
extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = showDetails(tableView: tableView, indexPath: IndexPath(row: 0, section: 0))
        switch segmentControl.selectedSegmentIndex {
        case 0:
            tableView.rowHeight = UITableView.automaticDimension
            cell = showDetails(tableView: tableView, indexPath: indexPath)
        case 1:
            tableView.rowHeight = UITableView.automaticDimension
            cell = showReviews(tableView: tableView, indexPath: indexPath)
        case 2:
            cell = showRelated(tableView: tableView, indexPath: indexPath)
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    func showDetails(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentAbout", for: indexPath) as! AboutSegmentTableViewCell
            if let data = movieData {
                cell.about.text = data.overview
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "informationSegment", for: indexPath)
            return cell
        }
    }
    
    func showReviews(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! RatingTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addReviewCell", for: indexPath) as! AddReviewTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    func showRelated(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as! PopularViewCell
            var path = ""
            if let data = movieData {
                path = "\(data.id ?? 0)/similar"
                cell.loadAPI(typeMovie: path)
                cell.categoryTitle.font = cell.categoryTitle.font.withSize(15.0)
                cell.categoryTitle.text = "Similar with \(data.title ?? "")"
                cell.seeAllBtn.isHidden = true
                cell.delegate = self
                tableView.rowHeight = cell.viewCollection.frame.size.height
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as! PopularViewCell
            var path = ""
            if let data = movieData {
                path = "\(data.id ?? 0)/recommendations"
                cell.loadAPI(typeMovie: path)
                cell.categoryTitle.font = cell.categoryTitle.font.withSize(15.0)
                cell.categoryTitle.text = "Recomendations for you"
                cell.seeAllBtn.isHidden = true
                cell.delegate = self
                tableView.rowHeight = cell.viewCollection.frame.size.height
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}


//MARK: - Segues Delegates Section
extension MovieDetailViewController: AddReviewDelegates, ViewCellDelegator {
    func goToAll(type: String) {
        //DO NOTHING
    }
    
    func gotoDetail(movie: Movie) {
        movieToSend = movie
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "movieDetail") as! MovieDetailViewController
            if let movieData = movieToSend {
                vc.movieData = movieData
            }
        self.navigationController!.pushViewController(vc, animated:true)
    }
    
    func goToAddReview() {
        performSegue(withIdentifier: "goToAddReview", sender: self)
    }
    
}
