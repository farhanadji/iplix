//
//  AccountViewController.swift
//  iplix
//
//  Created by Farhan Adji on 09/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    lazy var doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneHandler))
    var cellSection: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationController()
        setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AccountTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: K.identifier.account)
        tableView.register(UINib(nibName: "LogoutTableViewCell", bundle: nil), forCellReuseIdentifier: K.identifier.logout)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        if Auth.auth().currentUser != nil {
            cellSection = 2
        }
    }
    
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    }
    
    func setupNavigationController() {
        navigationItem.title = "Account"
        doneBtn.style = .done
        navigationItem.rightBarButtonItem = doneBtn
        
    }
    
    @objc func doneHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.identifier.goAccountDetail {
//            let vc = segue.destination as! DetailAccountViewController
//            vc.email = Auth.auth().currentUser?.email
//            vc.name = Auth.auth().currentUser?.displayName
//        }
//    }
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cellSection)
        return cellSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.account, for: indexPath) as! AccountTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.logout, for: indexPath) as! LogoutTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        if Auth.auth().currentUser != nil {
//            performSegue(withIdentifier: K.identifier.goAccountDetail, sender: self)
            let detailVC = DetailAccountViewController()
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
//            performSegue(withIdentifier: K.identifier.goLogin, sender: self)
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 70
//        } else {
//            return UITableView.automaticDimension
//        }
//    }
}

extension AccountViewController: LogoutDelegate {
    func logout() {
        
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
            self.cellSection = 1
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: K.text.no,
                                      style: .cancel,
                                      handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func logoutHandler(){
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        cellSection = 1
    }
}
