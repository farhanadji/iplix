//
//  SlideViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 08/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import SDWebImage

class SlideViewCell: UITableViewCell {

    @IBOutlet weak var movieCollection: UICollectionView!
    
    let network: NetworkManager = NetworkManager()
    var movies: [Movie] = []
    var moviesData: [Movie] = []
    var scrollingTimer = Timer()
    var rowIndex = 1
    let numberOfRecords: Int = 5
    override func awakeFromNib() {
        super.awakeFromNib()
        movieCollection.dataSource = self
        movieCollection.delegate = self
        movieCollection.register(UINib(nibName: "SlideCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sliderCell")
        network.getMovies(typeMovie: "popular") { response in
            self.moviesData = response
            self.movies.append(contentsOf: self.moviesData.prefix(upTo: 6))
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
            }
        }
        
        let cellWidth = 370
        let cellHeight = 180
        let insetX = (movieCollection.bounds.width - CGFloat(cellWidth)) / 2.0
        let insetY = (movieCollection.bounds.height - CGFloat(cellHeight)) / 2.0
        movieCollection.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        DispatchQueue.main.async {
            self.scrollingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.startTimer(theTimer:)), userInfo: self.rowIndex, repeats: true)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("selected")        // Configure the view for the selected state
    }
    
}

extension SlideViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! SlideCollectionViewCell
        cell.imageBanner.sd_setImage(with: URL(string: network.posterOriginalURL + movies[indexPath.row].backdrop_path!), completed: nil)
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.movieCollection.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    @objc func startTimer(theTimer: Timer) {
        if rowIndex < numberOfRecords {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut , animations: {
                self.movieCollection.scrollToItem(at: IndexPath(row: self.rowIndex, section: 0 ), at: .centeredHorizontally, animated: false)
            }, completion: nil)
              rowIndex = (rowIndex + 1)
        } else {
            rowIndex = 0
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut , animations: {
                       self.movieCollection.scrollToItem(at: IndexPath(row: self.rowIndex, section: 0 ), at: .centeredHorizontally, animated: false)
                   }, completion: nil)
        }
    }
    
    
}
