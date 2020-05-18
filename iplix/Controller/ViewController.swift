//
//  ViewController.swift
//  iplix
//
//  Created by Farhan Adji on 01/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ViewController: UIViewController {
    let tableView = UITableView()
    //    @IBOutlet weak var sliderCollection: UICollectionView!
    //    @IBOutlet weak var accountBtn: UIBarButtonItem!
    //    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var notificationButton: UIBarButtonItem!
    let accountBtn = UIBarButtonItem()
    let notificationBtn = UIBarButtonItem()
    let menuBtn = UIBarButtonItem()
    var movieToSend: Movie?
    var type: String = ""
    var menuView = HamburgerMenu.instance
    
    override func viewDidLoad() {
        print("didload called")
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        setupMenu()
        setupGesture()
        tableView.dataSource = self
        tableView.delegate = self
        tableView
            .register(
                UINib(nibName: K.nib.popularview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.popular)
        tableView
            .register(
                UINib(nibName: K.nib.sliderview,
                      bundle: nil),
                forCellReuseIdentifier: K.identifier.sliderTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUserMenu()
    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        print("willappear called")
    //        if Auth.auth().currentUser == nil {
    //            DispatchQueue.main.async {
    //                self.notificationButton.isEnabled = false
    //            }
    //        }
    //    }
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let backItem = UIBarButtonItem()
    //        backItem.title = K.text.back
    //        navigationItem.backBarButtonItem = backItem
    //
    //        if segue.identifier == K.identifier.goDetailFromHome {
    //            if let vc = segue.destination as? MovieDetailViewController {
    //                if let movieData = movieToSend {
    //                    vc.movieData = movieData
    //                }
    //            }
    //        }
    //
    //        if segue.identifier == K.identifier.goAllFromHome {
    //            if let vc = segue.destination as? MorePageViewController {
    //                vc.type = type
    //                vc.sender = K.identifier.senderHome
    //            }
    //        }
    //    }
    //
    //    @IBAction func accountBtnPressed(_ sender: UIBarButtonItem) {
    //        performSegue(withIdentifier: K.identifier.goAccount, sender: self)
    //    }
    
    func setupTableView(){
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.separatorStyle = .none
    }
    
    func setupNavigationController(){
        accountBtn.image = UIImage(systemName: "person.circle")
        accountBtn.target = self
        accountBtn.action = #selector(accountBarTapped)
        notificationBtn.target = self
        notificationBtn.action = #selector(notificationBarTapped)
        notificationBtn.image = UIImage(systemName: "bell.fill")
        menuBtn.target = self
        menuBtn.image = UIImage(systemName: "list.dash")
        menuBtn.action = #selector(menuTapped)
        navigationItem.rightBarButtonItems = [accountBtn, notificationBtn]
        navigationItem.leftBarButtonItem = menuBtn
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "iplix"
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func accountBarTapped() {
        print("tapped")
        let accountVC = AccountViewController()
        let navigation = UINavigationController()
        navigation.viewControllers = [accountVC]
        navigationController?.showDetailViewController(navigation, sender: self)
    }
    
    @objc func notificationBarTapped() {
//        let notificationVC = NotificationViewController()
//        navigationController?.pushViewController(notificationVC, animated: true)
//        let testVC = TestViewController()
        let mainVC = MainPagerViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(mainVC, animated: true)
        
    }
    
    func setupMenu() {
        let tapHome = UITapGestureRecognizer(target: self, action: #selector(homeTapped))
        let tapProduct = UITapGestureRecognizer(target: self, action: #selector(productTapped))
        let tapOrder = UITapGestureRecognizer(target: self, action: #selector(orderTapped))
        let tapAnalytics = UITapGestureRecognizer(target: self, action: #selector(analyticsTapped))
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        let swipeDismiss = UISwipeGestureRecognizer(target: self, action: #selector(dismissTapped))
        let tapAccount = UITapGestureRecognizer(target: self, action: #selector(accountTapped))
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(logoutTapped))
        swipeDismiss.direction = .left
        menuView.dimBackground.addGestureRecognizer(swipeDismiss)
        menuView.homeButton.addGestureRecognizer(tapHome)
        menuView.orderButton.addGestureRecognizer(tapOrder)
        menuView.productButton.addGestureRecognizer(tapProduct)
        menuView.analyticsButton.addGestureRecognizer(tapAnalytics)
        menuView.dimBackground.addGestureRecognizer(tapDismiss)
        menuView.accountButton.addGestureRecognizer(tapAccount)
        menuView.logoutButton.addGestureRecognizer(tapLogout)
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: K.text.signOut,
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: K.text.yes,
                                      style: .destructive,
                                      handler:
            { action in
                do {
                    try Auth.auth().signOut()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                self.menuView.dismiss()
        }))
        alert.addAction(UIAlertAction(title: K.text.no,
                                            style: .cancel,
                                            handler: nil))
        self.present(alert, animated: true)
        DispatchQueue.main.async {
            self.setUserMenu()
        }
    }
    
    @objc func accountTapped() {
        menuView.dismiss()
        self.accountBarTapped()
    }
    
    @objc func menuTapped() {
        setUserMenu()
        menuView.showMenu()
    }
    
    func setupGesture() {
        let edgeLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(menuTapped))
        edgeLeft.edges = .left
        view.addGestureRecognizer(edgeLeft)
    }
    
    func setUserMenu() {
        if let userLogged = Auth.auth().currentUser {
            menuView.avatar.sd_setImage(with: userLogged.photoURL)
            menuView.email.text = userLogged.email
            menuView.name.text = userLogged.displayName
            menuView.logoutButton.isHidden = false
        } else {
            menuView.avatar.image = UIImage(systemName: "person.circle.fill")
            menuView.avatar.tintColor = UIColor(named: "blibliPrimary")
            menuView.email.text = "Login/ Register"
            menuView.name.text = "iplix"
            menuView.logoutButton.isHidden = true
        }
    }
    
    @objc func dismissTapped() {
        menuView.dismiss()
    }
    
    @objc func homeTapped() {
        tabBarController?.selectedIndex = 0
        menuView.homeTapped()
    }
    
    @objc func productTapped() {
        tabBarController?.selectedIndex = 1
        menuView.productTapped()
    }
    
    @objc func orderTapped() {
        tabBarController?.selectedIndex = 2
        menuView.orderTapped()
    }
    
    @objc func analyticsTapped() {
        tabBarController?.selectedIndex = 3
        menuView.analyticsTapped()
    }
    
}



//MARK: - UITableView
extension ViewController: UITableViewDataSource, UITableViewDelegate, ViewCellDelegator {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.sliderTable, for: indexPath) as! SlideViewCell
            print(cell.frame.height)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular,for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.popular
            cell.loadAPI(typeMovie: K.typeMovie.popular)
            cell.delegate = self
            cell.type = K.typeMovie.popular
            print(tableView.frame.height)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular, for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.now_playing
            cell.loadAPI(typeMovie: K.typeMovie.now_playing)
            cell.delegate = self
            cell.type = K.typeMovie.now_playing
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular, for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.upcoming
            cell.loadAPI(typeMovie: K.typeMovie.upcoming)
            cell.delegate = self
            cell.type = K.typeMovie.upcoming
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.popular, for: indexPath) as! PopularViewCell
            cell.categoryTitle.text = K.text.top_rated
            cell.loadAPI(typeMovie: K.typeMovie.top_rated)
            cell.delegate = self
            cell.type = K.typeMovie.top_rated
            return cell
        }
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        var height: CGFloat = CGFloat()
    //        if indexPath.row == 0 {
    //            height = CGFloat(K.size.sliderHeight)
    //        } else {
    //            height = CGFloat(K.size.movieCollectionHeight)
    //        }
    //        return height
    //    }
    
    func gotoDetail(movie: Movie) {
        //        movieToSend = movie
        let detailVC = MovieDetailViewController()
        detailVC.movieData = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func goToAll(type: String) {
        //        self.type = type
        //        performSegue(withIdentifier: K.identifier.goAllFromHome, sender: self)
        let moreVC = MorePageViewController()
        moreVC.type = type
        moreVC.sender = K.identifier.senderHome
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    
}


