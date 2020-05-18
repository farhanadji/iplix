//
//  TestViewController.swift
//  iplix
//
//  Created by Farhan Adji on 13/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var chipView: UICollectionView!
    let chips = ["Order", "Product Q & A", "Product"]
    let orders = ["Order 1", "Order 2", "Order 3"]
    let productsQA = ["QA 1", "QA 2", "QA 3"]
    let products = ["Product 1", "Product 2", "Product 3"]
    var data: [[String]] = []
    var currentPosition = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        data = [orders, productsQA, products]
        chipView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "chipCell")
        chipView.delegate = self
        chipView.dataSource = self
        chipView.allowsMultipleSelection = false
        chipView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: K.identifier.category)
    }
    
    func setCurrentPosition(position: Int) {
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)
        
        DispatchQueue.main.async {
            self.chipView.selectItem(at: path, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
        
        self.chipView.reloadData()
        self.tableView.reloadData()
    }
}


extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chipCell", for: indexPath) as! ChipsCollectionViewCell
        cell.titleLabel.text = chips[indexPath.row]
        
        var didSelect = false
        
        if currentPosition == indexPath.row {
            didSelect = true
        }
        
        cell.select(didSelect: didSelect)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = chips[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCurrentPosition(position: indexPath.row)
    }
    
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifier.category, for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.text = data[currentPosition][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
