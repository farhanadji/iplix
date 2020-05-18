//
//  AddReviewViewController.swift
//  iplix
//
//  Created by Farhan Adji on 04/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class AddReviewViewController: UIViewController {
    
    //    @IBOutlet weak var ratingTable: UITableView!
    //    @IBOutlet weak var btnCancel: UIBarButtonItem!
    //    @IBOutlet weak var btnSend: UIBarButtonItem!
    lazy var btnCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelHandler))
    lazy var btnSend = UIBarButtonItem()
    let ratingTable = UITableView()
    var reviewText: String?
    var starsValue: Double?
    var titleText: String?
    var movie_id: Int?
    let db = Firestore.firestore()
    var rating: Ratings?
    var docId: String?
    var newRating: Ratings?
    override func viewDidLoad() {
        let hud = JGProgressHUD(style: .dark)
        super.viewDidLoad()
        setupNavigationController()
        setupView()
        ratingTable.register(
            UINib(nibName: "StarRatingTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: K.identifier.rating)
        ratingTable.register(
            UINib(nibName: "TitleReviewTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: K.identifier.title)
        ratingTable.register(
            UINib(nibName: "ReviewCommentTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: K.identifier.review)
        ratingTable.delegate = self
        ratingTable.dataSource = self
        newRating = rating
    }
    
    func setupView() {
        view.addSubview(ratingTable)
        ratingTable.translatesAutoresizingMaskIntoConstraints = false
        ratingTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        ratingTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        ratingTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        ratingTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        ratingTable.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setupNavigationController() {
        btnSend.style = .done
        btnSend.title = "Send"
        btnSend.target = self
        btnSend.action = #selector(sendHandler)
        navigationItem.title = "Write a Review"
        navigationItem.leftBarButtonItem = btnCancel
        navigationItem.rightBarButtonItem = btnSend
        
    }
    
    //    @IBAction func buttonAction(_ sender: UIBarButtonItem) {
    @objc func sendHandler() {
        let hud = JGProgressHUD(style: .dark)
        //        if sender == btnSend {
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        let timestamp = Date().timeIntervalSince1970
        self.calculateRating(stars_value: starsValue)
        if let user = Auth.auth().currentUser {
            if let mov_id = movie_id {
                db
                    .collection(K.collection.reviews)
                    .addDocument(data:
                        [K.reviews_attr.email: user.email!,
                         K.reviews_attr.name: user.displayName!,
                         K.reviews_attr.movie: mov_id,
                         K.reviews_attr.stars: starsValue ?? 0,
                         K.reviews_attr.title: titleText!,
                         K.reviews_attr.review: reviewText!,
                         K.reviews_attr.time: timestamp])
                    { error in
                        if let e = error {
                            print(e)
                            let alert = UIAlertController(title: K.text.errorTitle, message: e.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: K.text.ok, style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            self.db
                                .collection(K.collection.ratings)
                                .document(self.docId!).setData([
                                    K.ratings_attr.movie: self.newRating?.movie_id,
                                    K.ratings_attr.count: self.newRating?.rating_count,
                                    K.ratings_attr.average: self.newRating?.rating_average,
                                    K.ratings_attr.onestars: self.newRating?.one_stars,
                                    K.ratings_attr.twostars: self.newRating?.two_stars,
                                    K.ratings_attr.threestars: self.newRating?.three_stars,
                                    K.ratings_attr.fourstars: self.newRating?.four_stars,
                                    K.ratings_attr.five_stars: self.newRating?.five_stars
                                ]) { error in
                                    if let e = error {
                                        print(e)
                                    }
                                    hud.dismiss()
                                    
                            }
                            let alert = UIAlertController(title: K.text.successReviewMsg, message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: K.text.ok, style: .default, handler: { handler in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true)
                        }
                }
            }
        }
    }
    //        }
    //    }
    //    @IBAction func buttonPressed(_ sender: UIButton) {
    @objc func cancelHandler() {
        //        if sender == btnCancel {
        dismiss(animated: true, completion: nil)
        //        }
    }
    //    }
    
    func calculateRating(stars_value: Double?) {
        var rate = stars_value
        if rate == nil {
            rate = 0
        }
        
        if let rating = rating {
            let count = rating.rating_count! + 1
            let total_stars = (rating.rating_average! * Double(rating.rating_count!)) + rate!
            let total_count = rating.rating_count! + 1
            let average = total_stars / Double(total_count)
            let one_stars = rate == 1.0 ? rating.one_stars! + 1 : rating.one_stars!
            let two_stars = rate == 2.0 ? rating.two_stars! + 1 : rating.two_stars!
            let three_stars = rate == 3.0 ? rating.three_stars! + 1 : rating.three_stars!
            let four_stars = rate == 4.0 ? rating.four_stars! + 1 : rating.four_stars!
            let five_stars = rate == 5.0 ? rating.five_stars! + 1 : rating.five_stars!
            let newRate = Ratings(movie_id: movie_id, rating_count: total_count, rating_average: average, one_stars: one_stars, two_stars: two_stars, three_stars: three_stars, four_stars: four_stars, five_stars: five_stars)
            self.newRating = newRate
        }
    }
}

extension AddReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.rating, for: indexPath) as! StarRatingTableViewCell
            cell.delegate = self
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.title, for: indexPath) as! TitleReviewTableViewCell
            cell.delegate = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.review, for: indexPath) as! ReviewCommentTableViewCell
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 2 {
//            let size = self.view.frame.size.width
//            return size
//        } else {
//            return UITableView.automaticDimension
//        }
//    }
}


extension AddReviewViewController: ReviewDelegate, StarsDelegate, TitleReviewDelegate {
    func getTitle(title: String) {
        self.titleText = title
    }
    
    func getReview(review: String) {
        self.reviewText = review
    }
    
    func getStars(stars: Double) {
        self.starsValue = stars
    }
}
