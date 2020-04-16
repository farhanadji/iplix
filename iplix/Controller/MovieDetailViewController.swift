//
//  MovieDetailViewController.swift
//  iplix
//
//  Created by Farhan Adji on 04/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var tableDetail: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var unfavoriteBtn: UIButton!
    @IBOutlet weak var indicatorFav: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    var isFavorite: Bool = false
    var favorite: Query?
    var movieData: Movie?
    var movieToSend: Movie?
    var casts: [Casts] = []
    var crews: [Crews] = []
    var reviews: [Review] = []
    let network: NetworkManager = NetworkManager()
    var tableSection: Int = 3
    var cellSize: CGFloat = 320
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        tableDetail.delegate = self
        tableDetail.dataSource = self
        tableDetail.register(UINib(nibName: "RatingTableViewCell", bundle: nil), forCellReuseIdentifier: "ratingCell")
        tableDetail.register(UINib(nibName: "AddReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "addReviewCell")
        tableDetail.register(UINib(nibName: "PopularViewCell", bundle: nil), forCellReuseIdentifier: "popularCell")
        tableDetail.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        segmentControl.selectedSegmentIndex = 0
        if let data = movieData {
            if let backdropImage = data.backdrop_path {
                backdrop.sd_setImage(with: URL(string: network.posterURL + backdropImage))
            } else {
                backdrop.sd_setImage(with: URL(string: "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/9/2/8/5/235829-6-eng-GB/Feed-Test-SIC-Feed-20142_news_large.jpg"))
            }
            imagePoster.sd_setImage(with: URL(string: network.posterURL + data.poster_path!))
            titleMovie.text = data.title!
        }
        
        network.getCasts(id: (movieData?.id)!) { cast,crew in
            self.casts = cast
            self.crews = crew
            self.tableDetail.reloadData()
        }
        
        favoriteBtn.layer.borderWidth = 1.0
        favoriteBtn.layer.borderColor = UIColor.systemBlue.cgColor
        
        favorite = db.collection("favorites")
            .whereField("movie.id", isEqualTo: movieData?.id)
            .whereField("user", isEqualTo: Auth.auth().currentUser?.email)
        favorite?.getDocuments { (snapshot, error) in
            if snapshot!.isEmpty {
                self.isFavorite = false
                self.indicatorFav.isHidden = true
                self.favoriteBtn.isHidden = false
                self.unfavoriteBtn.isHidden = true
            } else {
                DispatchQueue.main.async {
                    self.isFavorite = true
                    if(self.isFavorite){
                        self.indicatorFav.isHidden = true
                        self.favoriteBtn.isHidden = true
                        self.unfavoriteBtn.isHidden = false
                    }
                }
            }
        }
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            tableSection = 3
            tableDetail.reloadData()
        case 1:
            tableSection = 2 + reviews.count
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
    
    @IBAction func btnAction(_ sender: UIButton) {
        if sender == favoriteBtn {
            if let mov = movieData, let user = Auth.auth().currentUser?.email {
                let data = ["id": mov.id ,"popularity": mov.popularity, "vote_count": mov.vote_count, "poster_path": mov.poster_path,
                            "backdrop_path": mov.backdrop_path, "title": mov.title, "genre_ids": mov.genre_ids, "overview": mov.overview,
                            "release_date": mov.release_date, "vote_average": mov.vote_average] as [String : Any]
                db.collection("favorites").addDocument(data: ["user": user, "movie": data])
                { error in
                    if let e = error {
                        let alert = UIAlertController(title: "Error!", message: e.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Added to favorites!", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        self.favoriteBtn.isHidden = true
                        self.unfavoriteBtn.isHidden = false
                    }
                }
            }
        } else if sender == unfavoriteBtn {
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure want to remove \(movieData?.title ?? "") from favorites list ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                self.favorite?.getDocuments(completion: { (snapshot, error) in
                    snapshot?.documents[0].reference.delete()
                    self.favoriteBtn.isHidden = false
                    self.unfavoriteBtn.isHidden = true
                })
            }))
            self.present(alert, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddReview" {
            if let vc = segue.destination as? UINavigationController {
                if let targetController = vc.topViewController as? AddReviewViewController {
                    if let id = movieData?.id {
                        targetController.movie_id = id
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        var reviews = db.collection("reviews").whereField("movie_id", isEqualTo: movieData?.id!).order(by: "timestamp", descending: true)
        reviews.addSnapshotListener { (snapshot, error) in
            self.reviews = []
            if let snapshotDocuments = snapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()
                    print(data)
                    self.reviews.append(self.parseDataReview(data: data))
                }
                self.tableSection = 2 + self.reviews.count
                self.tableDetail.reloadData()
            }
        }
    }
    
    func parseDataReview(data: [String: Any]) -> Review {
        let movie_id = data["movie_id"] as? Int
        let user_email = data["user_email"] as? String
        let user_name = data["user_name"] as? String
        let stars_value = data["stars_value"] as? Double
        let review = data["review"] as? String
        let title = data["title"] as? String
        let timestamp = data["timestamp"] as? Double
        
        let data = Review(movie_id: movie_id, review: review, stars_value: stars_value, title: title, user_email: user_email, user_name: user_name, timestamp: timestamp)
        print()
        return data
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
        } else if indexPath.row == 1 {
            var nameToLabel: String = ""
            let cell = tableView.dequeueReusableCell(withIdentifier: "castSegment", for: indexPath) as! CastSegmentTableViewCell
            let castLimit = casts.prefix(15)
            castLimit.map { cast in
                nameToLabel = nameToLabel + "\(cast.name ?? "")\n"
            }
            
            let director = crews.filter { $0.department == "Directing" && $0.job == "Director" }.first
            let writers = crews.filter { $0.department == "Writing" && $0.job == "Screenplay" }
            var writerToLabel: String = ""
            writers.map { writer in
                writerToLabel = writerToLabel + "\(writer.name ?? "")\n"
            }
            
            let producers = crews.filter { $0.department == "Production" && $0.job == "Producer" }
            var producersToLabel: String = ""
            producers.map { producer in
                producersToLabel = producersToLabel + "\(producer.name ?? "")\n"
            }
            cell.castNameLabel.text = nameToLabel
            cell.directorNameLabel.text = director?.name
            cell.writerNameLabel.text = writerToLabel
            cell.producerNameLabel.text = producersToLabel
            cell.castNameLabel.sizeToFit()
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
        } else if indexPath.row == 1 {
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: "addReviewCell", for: indexPath) as! AddReviewTableViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
            print("INDEX ROW: \(indexPath.row)")
            print("REVIEW COUNT: \(reviews.count)")
            if self.reviews.count > 0 {
                let idx = indexPath.row - 2
                cell.title.text = reviews[idx].title
                cell.username.text = reviews[idx].user_name
                if let value = reviews[idx].stars_value {
                    cell.rating.rating = value
                } else {
                    cell.rating.rating = 0.0
                }
                cell.review.text = reviews[idx].review
                
                if let timestamp = reviews[idx].timestamp {
                    let date = Date(timeIntervalSince1970: timestamp)
                    let formatter = RelativeDateTimeFormatter()
                    formatter.unitsStyle = .full
                    let stringDate = formatter.localizedString(for: date, relativeTo: Date())
                    cell.date.text = stringDate
                } else {
                    cell.date.text = ""
                }
            }
            return cell
        }
    }
    
    func showRelated(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 300
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as! PopularViewCell
        var path = ""
        if indexPath.row == 0 {
            if let data = movieData {
                path = "\(data.id ?? 0)/similar"
                cell.loadAPI(typeMovie: path)
                cell.categoryTitle.font = cell.categoryTitle.font.withSize(15.0)
                cell.categoryTitle.text = "Similar with \(data.title ?? "")"
                cell.seeAllBtn.isHidden = true
                cell.delegate = self
            }
            return cell
        } else if indexPath.row == 1 {
            var path = ""
            if let data = movieData {
                path = "\(data.id ?? 0)/recommendations"
                cell.loadAPI(typeMovie: path)
                cell.categoryTitle.font = cell.categoryTitle.font.withSize(15.0)
                cell.categoryTitle.text = "Recomendations for you"
                cell.seeAllBtn.isHidden = true
                cell.delegate = self
                //                tableView.rowHeight = cell.viewCollection.frame.size.height
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

extension MovieDetailViewController: UIScrollViewDelegate {
    
}

