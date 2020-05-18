//
//  CategoriesViewController.swift
//  iplix
//
//  Created by Farhan Adji on 17/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    let network = NetworkManager()
    var genres: [Genres] = []
    var genre_id: Int?
    var genre_title: String?
    let menuView = HamburgerMenu.instance
    let menuBtn = UIBarButtonItem()
//    @IBOutlet weak var categoryTableView: UITableView!
    let categoryTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupCategoryTableView()
        setupGesture()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(UINib(nibName: K.nib.categorytableview, bundle: nil), forCellReuseIdentifier: K.identifier.category)
        
        network.getGenres { response in
            self.genres = response
            self.categoryTableView.reloadData()
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.identifier.goMoreFromCategory {
//            let vc = segue.destination as? MorePageViewController
//            vc?.sender = K.identifier.senderCategory
//            vc?.genre_id = self.genre_id
//            vc?.type = self.genre_title!
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
//        FilterViewController.filters = FilterViewController.defaultFilter
    }
    
    func setupCategoryTableView() {
        view.addSubview(categoryTableView)
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        categoryTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        categoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
      func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Categories"
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

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.category, for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.text = genres[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.genre_id = genres[indexPath.row].id
//        self.genre_title = genres[indexPath.row].name
//        performSegue(withIdentifier: K.identifier.goMoreFromCategory, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        let moreVC = MorePageViewController()
        moreVC.sender = K.identifier.senderCategory
        moreVC.genre_id = genres[indexPath.row].id
        moreVC.type = genres[indexPath.row].name
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
}
