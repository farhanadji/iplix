//
//  Test4ViewController.swift
//  iplix
//
//  Created by Farhan Adji on 18/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

protocol BottomActionDelegate {
    func showBottomAction()
}

class Test4ViewController: UIViewController {
    let bottomActionButton = UIButton(type: .system)
    static var delegate: BottomActionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        view.addSubview(bottomActionButton)
        view.backgroundColor = .white
        bottomActionButton.translatesAutoresizingMaskIntoConstraints = false
        bottomActionButton.setTitle("Show Bottom Action View", for: .normal)
        bottomActionButton.setTitleColor(UIColor.white, for: .normal)
        bottomActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        bottomActionButton.backgroundColor = UIColor(named: "blibliPrimary")
        bottomActionButton.layer.cornerRadius = 10
        bottomActionButton.titleLabel?.textAlignment = .center
        bottomActionButton.addTarget(self, action: #selector(showBottomAction), for: .touchUpInside)
        bottomActionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        bottomActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        bottomActionButton.widthAnchor.constraint(equalToConstant: 210).isActive = true
        bottomActionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc func showBottomAction() {
        Test4ViewController.delegate?.showBottomAction()
    }
    
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//         filterVC.backgroundImage = self.navigationController?.view.asImage()
//         self.present(filterVC, animated: false, completion: nil)
//     }

}
