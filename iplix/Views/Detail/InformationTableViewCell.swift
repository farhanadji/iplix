//
//  InformationTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 20/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {
    @IBOutlet weak var studio: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var released: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
