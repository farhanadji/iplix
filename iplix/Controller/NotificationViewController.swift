//
//  NotificationViewController.swift
//  iplix
//
//  Created by Farhan Adji on 21/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase

class NotificationViewController: UIViewController {
    
    //    @IBOutlet weak var tableView: UITableView!
    let tableView = UITableView()
    let db = Firestore.firestore()
    var notification: [Notifications] = []
    let network = NetworkManager()
    var query: Query?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupView()
        tableView.register(
            UINib(nibName: "NotificationTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: K.identifier.notification)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db.collection("notifications").addSnapshotListener { (snapshot, error) in
            self.notification.removeAll()
            if let snapshotDocuments = snapshot?.documents {
                if !snapshotDocuments.isEmpty {
                    for doc in snapshotDocuments {
                        let doc = doc.data()
                        let movie = Helper.parseDataMovie(movieData: doc["movies"] as! [String : Any])
                        let notification = Notifications(title: doc["title"] as! String, description: doc["description"] as! String, movies: movie)
                        self.notification.append(notification)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func setupView() {
                view.addSubview(tableView)
        //                view.addSubview(chipView)
        view.backgroundColor = .systemBackground
        
        //
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.tableFooterView = UIView(frame: CGRect.zero)
                tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        //        tableView.rowHeight = 93
    }
    
    func setupNavigationController() {
        navigationItem.title = "Notifications"
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.notification, for: indexPath) as! NotificationTableViewCell
        cell.titleLabel.text = notification[indexPath.row].title
        cell.descriptionLabel.text = notification[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = MovieDetailViewController()
        detailVC.movieData = notification[indexPath.row].movies
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
