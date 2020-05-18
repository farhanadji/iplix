//
//  CastSegmentTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 07/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class CastSegmentTableViewCell: UITableViewCell {

    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var writerNameLabel: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    @IBOutlet weak var producerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
