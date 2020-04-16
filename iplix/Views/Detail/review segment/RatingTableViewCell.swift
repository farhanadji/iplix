//
//  RatingTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 04/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var allRatingStars: CosmosView!
    @IBOutlet weak var allRatingLabel: UILabel!
    @IBOutlet weak var pbFiveStars: UIProgressView!
    @IBOutlet weak var pbFourStars: UIProgressView!
    @IBOutlet weak var pbThreeStars: UIProgressView!
    @IBOutlet weak var pbTwoStars: UIProgressView!
    @IBOutlet weak var pbOneStars: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        allRatingStars.settings.fillMode = .precise
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


