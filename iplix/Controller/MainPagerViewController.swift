//
//  MainPagerViewController.swift
//  iplix
//
//  Created by Farhan Adji on 14/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class MainPagerViewController: SlidingTabController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addItem(item: TestViewController(), title: "General")
        addItem(item: Test2ViewController(), title: "Chips")
        addItem(item: Test3ViewController(), title: "Popup dialog")
        addItem(item: Test4ViewController(), title: "Bottom Action")
        Test4ViewController.delegate = self
        setHeaderActiveColor(color: UIColor(named: "blibliPrimary")!)
        setHeaderInActiveColor(color: .label)
        setHeaderBackgroundColor(color: .white)
        setStyle(style: .flexible)
        build()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Notification"
        navigationController?.navigationBar.barTintColor = UIColor(named: "blibliPrimary")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .link
    }
}

extension MainPagerViewController: BottomActionDelegate {
    func showBottomAction() {
        let vc = BottomActionViewController()
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            vc.backgroundImage = self.navigationController?.view.asImage()
            self.present(vc, animated: false, completion: nil)
        }
    }
}
