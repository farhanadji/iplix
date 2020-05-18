//
//  RegisterViewController.swift
//  iplix
//
//  Created by Farhan Adji on 13/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    //    @IBOutlet weak var nameTextField: UITextField!
    //    @IBOutlet weak var emailTextField: UITextField!
    //    @IBOutlet weak var passwordTextField: UITextField!
    //    @IBOutlet weak var registerBtn: UIButton!
    let titleLabel = UILabel()
    let nameTextFiled = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let registerBtn = UIButton(type: UIButton.ButtonType.system)
    var alertView = AlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegisterView()
        // Do any additional setup after loading the view.
    }
    
    func setupRegisterView() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(nameTextFiled)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerBtn)
        
        titleLabel.text = "Sign Up"
        titleLabel.textColor = .label
        titleLabel.font = titleLabel.font.withSize(22.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        nameTextFiled.placeholder = "Name"
        nameTextFiled.borderStyle = .roundedRect
        nameTextFiled.font = nameTextFiled.font?.withSize(17.0)
        nameTextFiled.translatesAutoresizingMaskIntoConstraints = false
        nameTextFiled.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        nameTextFiled.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        nameTextFiled.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        emailTextField.placeholder = "Email"
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.font = emailTextField.font?.withSize(17.0)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        passwordTextField.placeholder = "Password"
        passwordTextField.autocapitalizationType = .none
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.keyboardType = .default
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = passwordTextField.font?.withSize(17.0)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        registerBtn.setTitle("Register", for: UIControl.State.normal)
        registerBtn.titleLabel?.textAlignment = .center
        registerBtn.layer.cornerRadius = 5
        registerBtn.setTitleColor(.white, for: .normal)
        registerBtn.backgroundColor = .link
        registerBtn.titleLabel?.font = registerBtn.titleLabel?.font.withSize(18.0)
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25).isActive = true
        registerBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        registerBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        registerBtn.addTarget(self, action: #selector(registerHandler), for: .touchUpInside)
    }
    
    @objc func registerHandler() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextFiled.text!
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                hud.dismiss(afterDelay: 0.5)
//                let alert = UIAlertController(title: K.text.signUpFailed,
//                                              message: error?.localizedDescription,
//                                              preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: K.text.ok,
//                                              style: .default,
//                                              handler: nil))
//                self.present(alert, animated: true)
                let alert = AlertView()
                self.alertView = alert
                alert.setAlert(title: K.text.signUpFailed, message: error!.localizedDescription, alertType: .error)
                alert.btnOk.addTarget(self, action: #selector(self.btnErrorHandler), for: .touchUpInside)
            } else {
                if let user = Auth.auth().currentUser {
                    hud.dismiss(afterDelay: 0.5)
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges { error in
                        print(error)
                    }
                    let alert = AlertView()
                    self.alertView = alert
                    alert.setAlert(title: K.text.signUpSuccess, message: K.text.signUpMessage, alertType: .success)
                    alert.btnOk.addTarget(self, action: #selector(self.btnOkHandler), for: .touchUpInside)
//                    let alert = UIAlertController(title: K.text.signUpSuccess,
//                                                  message: K.text.signUpMessage,
//                                                  preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: K.text.ok,
//                                                  style: .default,
//                                                  handler: { handler in
//                                                    self.dismiss(animated: true, completion: nil)
//                    }))
//                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func btnOkHandler() {
        alertView.hideAlert()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnErrorHandler() {
        alertView.hideAlert()
    }
    
    //    @IBAction func buttonPressed(_ sender: UIButton) {
    //        let hud = JGProgressHUD(style: .dark)
    //        hud.textLabel.text = "Loading"
    //        hud.show(in: self.view)
    //        let email = emailTextField.text!
    //        let password = passwordTextField.text!
    //        let name = nameTextField.text!
    //        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
    //            if error != nil {
    //                hud.dismiss(afterDelay: 0.5)
    //                let alert = UIAlertController(title: K.text.signUpFailed,
    //                                              message: error?.localizedDescription,
    //                                              preferredStyle: .alert)
    //                alert.addAction(UIAlertAction(title: K.text.ok,
    //                                              style: .default,
    //                                              handler: nil))
    //                self.present(alert, animated: true)
    //            } else {
    //                if let user = Auth.auth().currentUser {
    //                    hud.dismiss(afterDelay: 0.5)
    //                    let changeRequest = user.createProfileChangeRequest()
    //                    changeRequest.displayName = name
    //                    changeRequest.commitChanges { error in
    //                        print(error)
    //                    }
    //                    let alert = UIAlertController(title: K.text.signUpSuccess,
    //                                                  message: K.text.signUpMessage,
    //                                                  preferredStyle: .alert)
    //                    alert.addAction(UIAlertAction(title: K.text.ok,
    //                                                  style: .default,
    //                                                  handler: { handler in
    //                                                    self.dismiss(animated: true, completion: nil)
    //                    }))
    //                    self.present(alert, animated: true)
    //                }
    //            }
    //        }
    //    }
}

extension RegisterViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.endEditing(true)
    }
}
