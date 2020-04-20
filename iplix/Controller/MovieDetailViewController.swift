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
import JGProgressHUD

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
    var genres: [Genres] = []
    var studios: [ProductionCompany] = []
    var ratings: Ratings?
    var docId: String?
    let network: NetworkManager = NetworkManager()
    var tableSection: Int = 3
    let hud = JGProgressHUD(style: .dark)
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        scrollView.delegate = self
        tableDetail.delegate = self
        tableDetail.dataSource = self
        tableDetail
            .register(
                UINib(nibName: K.nib.ratingview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.rating)
        tableDetail
            .register(
                UINib(nibName: K.nib.addreviewview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.addreview)
        tableDetail
            .register(
                UINib(nibName: K.nib.popularview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.popular)
        tableDetail
            .register(
                UINib(nibName: K.nib.commentview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.comment)
        segmentControl.selectedSegmentIndex = 0
        
        if let data = movieData {
            if let backdropImage = data.backdrop_path {
                backdrop.sd_setImage(with: URL(string: network.posterURL + backdropImage))
            } else {
                backdrop.sd_setImage(with: URL(string: K.URL.default_backdrop))
            }
            imagePoster.sd_setImage(with: URL(string: network.posterURL + data.poster_path!))
            titleMovie.text = data.title!
        }
        
        network.getCasts(id: (movieData?.id)!) { cast,crew in
            self.casts = cast
            self.crews = crew
            self.tableDetail.reloadData()
        }
        
        network.getMovieDetail(id: (movieData?.id)!) { studios in
            self.studios = studios
            self.tableDetail.reloadData()
        }
        
        network.getGenres { genres in
            self.genres = genres
            self.tableDetail.reloadData()
        }
        
        favoriteBtn.layer.borderWidth = 1.0
        favoriteBtn.layer.borderColor = UIColor.systemBlue.cgColor
        
        favorite = db
            .collection(K.collection.favorites)
            .whereField(K.favorites_attr.movie_id,
                        isEqualTo: movieData?.id)
            .whereField(K.favorites_attr.user, isEqualTo: Auth.auth().currentUser?.email)
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
            self.hud.dismiss(afterDelay: 1.0)
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
            tableSection = 2
            tableDetail.reloadData()
        default:
            tableSection = 1
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        if sender == favoriteBtn {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            if Auth.auth().currentUser == nil {
                let storyboard = UIStoryboard(name: K.identifier.main, bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: K.identifier.signin_page) as! LoginViewController
                self.navigationController!.pushViewController(vc, animated:true)
                hud.dismiss()
            } else {
                if let mov = movieData, let user = Auth.auth().currentUser?.email {
                    let data = [
                        K.favorites_attr.id: mov.id,
                        K.favorites_attr.popularity: mov.popularity,
                        K.favorites_attr.vote: mov.vote_count,
                        K.favorites_attr.poster: mov.poster_path,
                        K.favorites_attr.backdrop: mov.backdrop_path,
                        K.favorites_attr.title: mov.title,
                        K.favorites_attr.genre: mov.genre_ids,
                        K.favorites_attr.overview: mov.overview,
                        K.favorites_attr.release: mov.release_date,
                        K.favorites_attr.vote_average: mov.vote_average] as [String : Any]
                    db
                        .collection(K.collection.favorites)
                        .addDocument(data: [K.favorites_attr.user: user,
                                            K.favorites_attr.movie: data])
                        { error in
                            hud.dismiss(afterDelay: 1.0)
                            if let e = error {
                                let alert = UIAlertController(title: K.text.errorTitle,
                                                              message: e.localizedDescription,
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: K.text.ok,
                                                              style: .default,
                                                              handler: nil))
                                self.present(alert, animated: true)
                            } else {
                                let alert = UIAlertController(title: K.text.add_favorite,
                                                              message: "",
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: K.text.ok,
                                                              style: .default,
                                                              handler: nil))
                                self.present(alert, animated: true)
                                self.favoriteBtn.isHidden = true
                                self.unfavoriteBtn.isHidden = false
                            }
                    }
                }
            }
        } else if sender == unfavoriteBtn {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Loading"
            let alert = UIAlertController(title: K.text.confirmation,
                                          message: "\(K.text.remove_message1) \(movieData?.title ?? "") \(K.text.remove_message2)",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: K.text.no,
                                          style: .cancel,
                                          handler: nil))
            alert.addAction(UIAlertAction(title: K.text.yes,
                                          style: .destructive,
                                          handler:
                { action in
                    hud.show(in: self.view)
                    self.favorite?.getDocuments(completion: { (snapshot, error) in
                        snapshot?.documents[0].reference.delete()
                        self.favoriteBtn.isHidden = false
                        self.unfavoriteBtn.isHidden = true
                    })
                    hud.dismiss(afterDelay: 1.0)
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
            let shareViewController = UIActivityViewController(activityItems: [text],
                                                               applicationActivities: nil)
            shareViewController.popoverPresentationController?.sourceView = self.view
            self.present(shareViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.identifier.goReview {
            if let vc = segue.destination as? UINavigationController {
                if let targetController = vc.topViewController as? AddReviewViewController {
                    if let id = movieData?.id {
                        targetController.movie_id = id
                        targetController.rating = self.ratings
                        targetController.docId = self.docId
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        var reviews = db
            .collection(K.collection.reviews)
            .whereField(K.reviews_attr.movie, isEqualTo: movieData?.id!)
            .order(by: K.reviews_attr.time, descending: true)
        reviews.addSnapshotListener { (snapshot, error) in
            self.reviews = []
            if let snapshotDocuments = snapshot?.documents {
                for doc in snapshotDocuments {
                    let data = doc.data()
                    print(data)
                    self.reviews.append(Helper.parseDataReview(data: data))
                }
            }
            DispatchQueue.main.async {
                self.tableSection += 1
                self.tableDetail.reloadData()
            }
        }
        
        var ratings = db
            .collection(K.collection.ratings).whereField(K.ratings_attr.movie, isEqualTo: movieData?.id)
        ratings.addSnapshotListener { (snapshot, error) in
            if let snapshotDocuments = snapshot?.documents {
                if snapshotDocuments.isEmpty {
                    var createRatings: DocumentReference? = nil
                    createRatings = self.db.collection(K.collection.ratings).addDocument(data: [
                        K.ratings_attr.movie: self.movieData?.id,
                        K.ratings_attr.count: 0,
                        K.ratings_attr.average: 0,
                        K.ratings_attr.onestars: 0,
                        K.ratings_attr.twostars: 0,
                        K.ratings_attr.threestars: 0,
                        K.ratings_attr.fourstars: 0,
                        K.ratings_attr.five_stars: 0
                    ]) { error in
                        if let e = error {
                            print(e)
                        } else {
                            self.docId = createRatings?.documentID
                        }
                    }
                } else {
                    let data = snapshotDocuments[0].data()
                    self.docId = snapshotDocuments[0].documentID
                    print(data)
                    self.ratings = Helper.parseDataRating(ratingData: data)
                }
            }
            DispatchQueue.main.async {
                self.tableDetail.reloadData()
            }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.about, for: indexPath) as! AboutSegmentTableViewCell
            if let data = movieData {
                cell.about.text = data.overview
            }
            return cell
        } else if indexPath.row == 1 {
            var nameToLabel: String = ""
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.cast, for: indexPath) as! CastSegmentTableViewCell
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
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.information, for: indexPath) as! InformationTableViewCell
            if let movie = movieData {
                cell.released.text = movie.release_date?.components(separatedBy: "-")[0]
                if let genreId = movie.genre_ids {
                    let genre = genres.filter{ item in
                        genreId.contains(item.id)
                    }
                    
                    var genreToLabel: String = ""
                    genre.map { genre in
                        genreToLabel = genreToLabel + "\(genre.name ?? "")\n"
                    }
                    cell.genre.text = genreToLabel
                }
                var studioToLabel: String = ""
                studios.map { studio in
                    studioToLabel = studioToLabel + "\(studio.name ?? "")\n"
                }
                cell.studio.text = studioToLabel
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func showReviews(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.rating, for: indexPath) as! RatingTableViewCell
            if let rating = ratings {
                cell.allRatingStars.rating = Double((rating.rating_average)!)
                cell.allRatingLabel.text = String(rating.rating_count!)
                if rating.rating_count! > 0 {
                    print("YES COUNT > 0")
                    cell.pbOneStars.progress = Float(rating.one_stars!) / Float(rating.rating_count!)
                    cell.pbTwoStars.progress = Float(rating.two_stars!) / Float(rating.rating_count!)
                    cell.pbThreeStars.progress = Float(rating.three_stars!) / Float(rating.rating_count!)
                    cell.pbFourStars.progress = Float(rating.four_stars!) / Float(rating.rating_count!)
                    cell.pbFiveStars.progress = Float(rating.five_stars!) / Float(rating.rating_count!)
                }
            }
            return cell
        } else if indexPath.row == 1 {
            tableView.rowHeight = 44
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.addreview, for: indexPath) as! AddReviewTableViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.comment, for: indexPath) as! CommentTableViewCell
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
        tableView.rowHeight = CGFloat(K.size.movieCollectionHeight)
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular, for: indexPath) as! PopularViewCell
        var path = ""
        if indexPath.row == 0 {
            if let data = movieData {
                path = "\(data.id ?? 0)\(K.typeMovie.similar)"
                cell.loadAPI(typeMovie: path)
                cell.categoryTitle.font = cell.categoryTitle.font.withSize(CGFloat(K.size.titleSize))
                cell.categoryTitle.text = "\(K.text.similar) \(data.title ?? "")"
                cell.seeAllBtn.isHidden = true
                cell.delegate = self
            }
            return cell
        } else if indexPath.row == 1 {
            var path = ""
            if let data = movieData {
                path = "\(data.id ?? 0)\(K.typeMovie.recommendation)"
                cell.loadAPI(typeMovie: path)
                cell.categoryTitle.font = cell.categoryTitle.font.withSize(CGFloat(K.size.titleSize))
                cell.categoryTitle.text = K.text.recommendation
                cell.seeAllBtn.isHidden = true
                cell.delegate = self
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
        let storyboard = UIStoryboard(name: K.identifier.main, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: K.identifier.movie_datail) as! MovieDetailViewController
        if let movieData = movieToSend {
            vc.movieData = movieData
        }
        self.navigationController!.pushViewController(vc, animated:true)
    }
    
    func goToAddReview() {
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: K.identifier.main, bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: K.identifier.signin_page) as! LoginViewController
            self.navigationController!.pushViewController(vc, animated:true)
            hud.dismiss()
        } else {
            performSegue(withIdentifier: K.identifier.goReview, sender: self)
        }
    }
    
}

extension MovieDetailViewController: UIScrollViewDelegate {
    
}

