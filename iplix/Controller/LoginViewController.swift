//
//  LoginViewController.swift
//  iplix
//
//  Created by Farhan Adji on 13/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if sender == loginBtn {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if error != nil {
                    let alert = UIAlertController(title: "Sign In Failed!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self?.present(alert, animated: true)
                    self?.passwordTextField.text = ""
                } else {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        } else if sender == signUpBtn {
            performSegue(withIdentifier: "goToRegister", sender: self)
        }
    }
}

extension LoginViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.endEditing(true)
    }
}
