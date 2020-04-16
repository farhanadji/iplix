//
//  StarRatingTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 15/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Cosmos

protocol StarsDelegate {
    func getStars(stars: Double)
}

class StarRatingTableViewCell: UITableViewCell {

    @IBOutlet weak var stars: CosmosView!
    var delegate: StarsDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stars.didFinishTouchingCosmos = { rating in
            self.delegate?.getStars(stars: rating)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
