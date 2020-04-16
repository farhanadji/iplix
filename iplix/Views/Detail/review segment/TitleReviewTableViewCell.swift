//
//  TitleReviewTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 15/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
protocol TitleReviewDelegate {
    func getTitle(title: String)
}

class TitleReviewTableViewCell: UITableViewCell {
    
    var delegate: TitleReviewDelegate?
    @IBOutlet weak var title: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func titleChanged(_ sender: UITextField) {
        delegate?.getTitle(title: sender.text!)
    }
}
