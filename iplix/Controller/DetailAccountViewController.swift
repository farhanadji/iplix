//
//  DetailAccountViewController.swift
//  iplix
//
//  Created by Farhan Adji on 13/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class DetailAccountViewController: UIViewController {
    
    var profileTable = UITableView()
    //    @IBOutlet weak var doneBtn: UIBarButtonItem!
    lazy var doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnHandler))
    var name: String?
    var email: String?
    var user: User?
    var alertView: AlertView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationController()
        profileTable.delegate = self
        profileTable.dataSource = self
        profileTable.tableFooterView = UIView(frame: CGRect.zero)
        profileTable.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: K.identifier.profilePicture)
        profileTable.register(UINib(nibName: "NameProfileTableViewCell", bundle: nil), forCellReuseIdentifier: K.identifier.nameProfile)
        profileTable.register(UINib(nibName: "EmailProfileTableViewCell", bundle: nil), forCellReuseIdentifier: K.identifier.emailProfile )
        
        if let user = Auth.auth().currentUser {
            self.user = user
        }
    }
    
    func setupTableView() {
        view.addSubview(profileTable)
        profileTable.translatesAutoresizingMaskIntoConstraints = false
        profileTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        profileTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        profileTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        profileTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupNavigationController() {
        navigationItem.title = "Edit Profile"
        doneBtn.style = .done
        navigationItem.rightBarButtonItem = doneBtn
    }
    
    @objc func doneBtnHandler() {
        print("done clicked")
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        let userRequest = user?.createProfileChangeRequest()
        if name != nil {
            userRequest?.displayName = name
        }
        userRequest?.commitChanges(completion: { error in
            if error != nil {
                //                let alert = UIAlertController(title: K.text.errorTitle,
                //                                              message: error?.localizedDescription,
                //                                              preferredStyle: .alert)
                //                alert.addAction(UIAlertAction(title: K.text.ok, style: .default, handler: nil))
                //                self.present(alert, animated: true, completion: nil)
                let alert = AlertView()
                self.alertView = alert
                alert.setAlert(title: K.text.errorTitle, message: error!.localizedDescription, alertType: .error)
                alert.btnOk.addTarget(self, action: #selector(self.alertHandler), for: .touchUpInside)
            }
            //            let alert = UIAlertController(title: "Profile updated!",
            //                                          message: error?.localizedDescription,
            //                                          preferredStyle: .alert)
            //
            //            alert.addAction(UIAlertAction(title: K.text.ok,
            //                                          style: .default,
            //                                          handler: { handle in
            //                                            self.dismiss(animated: true, completion: nil)
            //            }))
            hud.dismiss()
            let alert = AlertView()
            self.alertView = alert
            alert.setAlert(title: "Success!", message: "Profile changes saved!", alertType: .success)
            alert.btnOk.addTarget(self, action: #selector(self.alertOkHandler), for: .touchUpInside)
            //            self.present(alert, animated: true)
        })
    }
    
    @objc func alertOkHandler() {
        alertView?.hideAlert()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func alertHandler() {
        alertView?.hideAlert()
    }
    
    //    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
    //        let hud = JGProgressHUD(style: .dark)
    //        hud.textLabel.text = "Loading"
    //        hud.show(in: self.view)
    //
    //        let userRequest = user?.createProfileChangeRequest()
    //        userRequest?.displayName = name
    //        userRequest?.commitChanges(completion: { error in
    //            if error != nil {
    //                let alert = UIAlertController(title: K.text.errorTitle,
    //                                              message: error?.localizedDescription,
    //                                              preferredStyle: .alert)
    //                alert.addAction(UIAlertAction(title: K.text.ok, style: .default, handler: nil))
    //                self.present(alert, animated: true, completion: nil)
    //            }
    //            hud.dismiss(afterDelay: 3.0)
    //            self.dismiss(animated: true, completion: nil)
    //        })
    //
    //    }
}

extension DetailAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.profilePicture, for: indexPath) as! ProfileTableViewCell
            cell.delegate = self
            if let avatar = user?.photoURL?.absoluteString {
                print("avatar table \(avatar)")
                DispatchQueue.main.async {
                    cell.avatarImage.sd_setImage(with: URL(string: avatar))
                }
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.nameProfile, for: indexPath) as! NameProfileTableViewCell
            cell.delegate = self
            if let user = Auth.auth().currentUser {
                cell.nameTextField.text = user.displayName
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.emailProfile, for: indexPath) as! EmailProfileTableViewCell
            if let user = Auth.auth().currentUser {
                cell.emailTextField.text = user.email
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160.0
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension DetailAccountViewController: DelegateImagePicker, NameEditDelegate {
    func getNameEdited(name: String) {
        self.name = name
        print(name)
    }
    
    func doneEditingAvatar(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        let storageRef = Storage.storage().reference(forURL: K.URL.storage)
        
        if let user = Auth.auth().currentUser {
            let storageProfileRef = storageRef.child(K.collection.profile).child(user.uid)
            
            let changeRequest = user.createProfileChangeRequest()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: K.text.errorTitle,
                                                  message: error?.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: K.text.ok, style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                storageProfileRef.downloadURL { (url, error) in
                    if let metaImageUrl = url?.absoluteString {
                        print(metaImageUrl)
                        changeRequest.photoURL = URL(string: metaImageUrl)
                        changeRequest.commitChanges { error in
                            if error != nil {
                                let alert = UIAlertController(title: K.text.errorTitle,
                                                              message: error?.localizedDescription,
                                                              preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: K.text.ok, style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            DispatchQueue.main.async {
                                self.profileTable.reloadData()
                                hud.dismiss(afterDelay: 1.0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showPicker(imagePicker: UIImagePickerController) {
        self.present(imagePicker, animated: true, completion: nil)
    }
}
