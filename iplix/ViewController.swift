//
//  ViewController.swift
//  iplix
//
//  Created by Farhan Adji on 01/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var accountBtn: UIBarButtonItem!
    
    var movies: [String] = ["Avengers hwhwhw hwhwhw", "Iron Man", "Money Heist", "Cibai"]
    var genres: [String] = ["Sci-fi", "Action", "Comedy", "Adult"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         collectionView.dataSource = self
         collectionView.delegate = self
        
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print(movies.count)
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieViewCell
        cell.title.text = movies[indexPath.row]
        cell.genre.text = genres[indexPath.row]
       
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(movies[indexPath.row])
    }
}

