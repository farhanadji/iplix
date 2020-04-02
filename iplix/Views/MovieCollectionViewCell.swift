//
//  MovieCollectionViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 02/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
