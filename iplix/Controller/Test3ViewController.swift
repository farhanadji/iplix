//
//  Test3ViewController.swift
//  iplix
//
//  Created by Farhan Adji on 15/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class Test3ViewController: UIViewController {
    let informationBtn = UIButton(type: .system)
    let alertBtn = UIButton(type: .system)
    let errorBtn = UIButton(type: .system)
    let successBtn = UIButton(type: .system)
    var alert = AlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(informationBtn)
        view.addSubview(alertBtn)
        view.addSubview(errorBtn)
        view.addSubview(successBtn)
        informationBtn.translatesAutoresizingMaskIntoConstraints = false
        informationBtn.setTitle("Show Information Dialog", for: .normal)
        informationBtn.setTitleColor(UIColor.white, for: .normal)
        informationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        informationBtn.backgroundColor = UIColor(named: "blibliPrimary")
        informationBtn.layer.cornerRadius = 10
        informationBtn.titleLabel?.textAlignment = .center
        informationBtn.addTarget(self, action: #selector(informationButton), for: .touchUpInside)
        informationBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        informationBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        informationBtn.widthAnchor.constraint(equalToConstant: 210).isActive = true
        informationBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true

        alertBtn.translatesAutoresizingMaskIntoConstraints = false
        alertBtn.setTitle("Show Alert Dialog", for: .normal)
        alertBtn.setTitleColor(UIColor(named: "blibliPrimary"), for: .normal)
        alertBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        alertBtn.titleLabel?.textAlignment = .center
        alertBtn.backgroundColor = .white
        alertBtn.layer.borderWidth = 1.0
        alertBtn.layer.borderColor = UIColor.systemGray4.cgColor
        alertBtn.layer.cornerRadius = 10
        alertBtn.addTarget(self, action: #selector(alertButton), for: .touchUpInside)
        alertBtn.topAnchor.constraint(equalTo: informationBtn.bottomAnchor, constant: 10).isActive = true
        alertBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        alertBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        alertBtn.widthAnchor.constraint(equalToConstant: 190).isActive = true
        
        errorBtn.translatesAutoresizingMaskIntoConstraints = false
        errorBtn.setTitle("Show Error Dialog", for: .normal)
        errorBtn.setTitleColor(UIColor.white, for: .normal)
        errorBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        errorBtn.backgroundColor = UIColor(named: "blibliRed")
        errorBtn.layer.cornerRadius = 10
        errorBtn.titleLabel?.textAlignment = .center
        errorBtn.addTarget(self, action: #selector(errorButton), for: .touchUpInside)
        errorBtn.topAnchor.constraint(equalTo: alertBtn.bottomAnchor, constant: 10).isActive = true
        errorBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        errorBtn.widthAnchor.constraint(equalToConstant: 190).isActive = true
        errorBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        successBtn.translatesAutoresizingMaskIntoConstraints = false
        successBtn.setTitle("Show Success Dialog", for: .normal)
        successBtn.setTitleColor(UIColor(named: "blibliRed"), for: .normal)
        successBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        successBtn.titleLabel?.textAlignment = .center
        successBtn.backgroundColor = .white
        successBtn.layer.borderWidth = 1.0
        successBtn.layer.borderColor = UIColor.systemGray4.cgColor
        successBtn.layer.cornerRadius = 10
        successBtn.addTarget(self, action: #selector(successButton), for: .touchUpInside)
        successBtn.topAnchor.constraint(equalTo: errorBtn.bottomAnchor, constant: 10).isActive = true
        successBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        successBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        successBtn.widthAnchor.constraint(equalToConstant: 190).isActive = true
    }
    
    @objc func informationButton() {
        let informationAlert = AlertView()
        informationAlert.setAlert(title: "Information", message: "test information", alertType: .information)
        alert = informationAlert
        informationAlert.btnOk.addTarget(self, action: #selector(btnOk), for: .touchUpInside)
    }
    
    @objc func alertButton() {
        let alertAlert = AlertView()
        alertAlert.setAlert(title: "Alert", message: "test alert", alertType: .alert)
        alert = alertAlert
        alertAlert.btnOk.addTarget(self, action: #selector(btnOk), for: .touchUpInside)
    }
    
    @objc func errorButton() {
        let errorAlert = AlertView()
        errorAlert.setAlert(title: "Error!", message: "error alert", alertType: .error)
        alert = errorAlert
        errorAlert.btnOk.addTarget(self, action: #selector(btnOk), for: .touchUpInside)
    }
    
    @objc func successButton() {
        let successAlert = AlertView()
        successAlert.setAlert(title: "Success!", message: "success alert", alertType: .success)
        alert = successAlert
        successAlert.btnOk.addTarget(self, action: #selector(btnOk), for: .touchUpInside)
    }
    
    @objc func btnOk(){
        alert.hideAlert()
    }
}
