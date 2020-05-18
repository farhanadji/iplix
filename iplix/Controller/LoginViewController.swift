//
//  LoginViewController.swift
//  iplix
//
//  Created by Farhan Adji on 13/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    //
    //    @IBOutlet weak var emailTextField: UITextField!
    //    @IBOutlet weak var loginBtn: UIButton!
    //    @IBOutlet weak var passwordTextField: UITextField!
    //    @IBOutlet weak var signUpBtn: UIButton!
    let mainView = UIView()
    let titleLogin = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    var alertView: AlertView?
    let loginButton = UIButton(type: UIButton.ButtonType.system)
    let registerButton = UIButton(type: UIButton.ButtonType.system)
//    let alert = AlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
//        alert.btnOk.addTarget(self, action: #selector(btnOkHandler), for: .touchUpInside)
    }
    
    
    func setupLoginView() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLogin)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        titleLogin.text = "Sign In"
        titleLogin.textColor = .label
        titleLogin.font = titleLogin.font.withSize(22.0)
        titleLogin.translatesAutoresizingMaskIntoConstraints = false
        titleLogin.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLogin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        
        emailTextField.placeholder = "Email"
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.font = emailTextField.font?.withSize(17.0)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: titleLogin.bottomAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        passwordTextField.placeholder = "Password"
        passwordTextField.autocapitalizationType = .none
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.keyboardType = .default
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = passwordTextField.font?.withSize(17.0)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        loginButton.setTitle("Login", for: UIControl.State.normal)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.layer.cornerRadius = 5
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .link
        loginButton.titleLabel?.font = loginButton.titleLabel?.font.withSize(18.0)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        loginButton.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        
        registerButton.setTitle("Don't have an account? Sign Up", for: UIControl.State.normal)
        registerButton.titleLabel?.textAlignment = .center
        registerButton.setTitleColor(.link, for: .normal)
        registerButton.titleLabel?.font = registerButton.titleLabel?.font.withSize(13.0)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        registerButton.addTarget(self, action: #selector(registerHandler), for: .touchUpInside)
        
    }
    
    
    @objc func loginHandler() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                hud.dismiss(afterDelay: 0.5)
//                let alert = UIAlertController(title: K.text.signInFailed,
//                                              message: error?.localizedDescription,
//                                              preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: K.text.ok,
//                                              style: .default,
//                                              handler: nil))
//
//                self?.present(alert, animated: true)
                print("salah called")
                let alert = AlertView()
//                alert.btnOk.isUserInteractionEnabled = true
                alert.setAlert(title: K.text.signInFailed, message: error!.localizedDescription, alertType: .error)
                self?.alertView = alert
                alert.btnOk.addTarget(self, action: #selector(self?.btnHandler), for: .touchUpInside)
                self?.passwordTextField.text = ""
                
            } else {
                hud.dismiss(afterDelay: 0.5)
                self?.dismiss(animated: true, completion: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func btnHandler(){
        alertView?.hideAlert()
    }
    
//
    @objc func registerHandler() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    //    @IBAction func buttonPressed(_ sender: UIButton) {
    //        let hud = JGProgressHUD(style: .dark)
    //        hud.textLabel.text = "Loading"
    //        hud.show(in: self.view)
    //        let email = emailTextField.text!
    //        let password = passwordTextField.text!
    //        if sender == loginBtn {
    //            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
    //                if error != nil {
    //                    hud.dismiss(afterDelay: 0.5)
    //                    let alert = UIAlertController(title: K.text.signInFailed,
    //                                                  message: error?.localizedDescription,
    //                                                  preferredStyle: .alert)
    //
    //                    alert.addAction(UIAlertAction(title: K.text.ok,
    //                                                  style: .default,
    //                                                  handler: nil))
    //
    //                    self?.present(alert, animated: true)
    //                    self?.passwordTextField.text = ""
    //                } else {
    //                    hud.dismiss(afterDelay: 0.5)
    //                    self?.dismiss(animated: true, completion: nil)
    //                    self?.navigationController?.popViewController(animated: true)
    //                }
    //            }
    //        } else if sender == signUpBtn {
    //            performSegue(withIdentifier: K.identifier.goRegister, sender: self)
    //        }
    //    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
}

