//
//  DetailViewController.swift
//  iplix
//
//  Created by Farhan Adji on 01/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailPoster: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var detailReleased: UILabel!
    @IBOutlet weak var detailVote: UILabel!
    
    var movie: Movie?
    var network: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if let movieData = movie {
            detailPoster.sd_setImage(with: URL(string: network.posterURL + movieData.poster_path!))
            detailTitle.text = movieData.title!
            overview.text = movieData.overview!
            detailReleased.text = movieData.release_date!
            detailVote.text = String(format: "%.1f", movieData.vote_average!)
        }
                // Do any additional setup after loading the view.
    }

}
