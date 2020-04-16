//
//  AddReviewViewController.swift
//  iplix
//
//  Created by Farhan Adji on 04/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase

class AddReviewViewController: UIViewController {
    
    @IBOutlet weak var ratingTable: UITableView!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnSend: UIBarButtonItem!
    var reviewText: String?
    var starsValue: Double?
    var titleText: String?
    var movie_id: Int?
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingTable.delegate = self
        ratingTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonAction(_ sender: UIBarButtonItem) {
        if sender == btnSend {
            print("clicked")
            let date = Date().timeIntervalSince1970
            if let user = Auth.auth().currentUser {
                if let mov_id = movie_id {
                    db.collection("reviews").addDocument(data: ["user_email": user.email, "user_name": user.displayName, "movie_id": mov_id, "stars_value": starsValue, "title": titleText , "review": reviewText, "timestamp": date]) { error in
                        if let e = error {
                            print(e)
                            let alert = UIAlertController(title: "Error!", message: e.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            print("success")
                            let alert = UIAlertController(title: "Success to add review!", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { handler in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == btnCancel {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension AddReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! StarRatingTableViewCell
            cell.delegate = self
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleReviewTableViewCell
            cell.delegate = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewCommentTableViewCell
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            let size = self.view.frame.size.width - 87
            return size
        } else {
            return UITableView.automaticDimension
        }
    }
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
