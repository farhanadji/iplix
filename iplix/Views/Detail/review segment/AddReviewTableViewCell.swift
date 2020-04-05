//
//  AddReviewTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 04/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

protocol AddReviewDelegates {
    func goToAddReview()
}

class AddReviewTableViewCell: UITableViewCell, AddReviewDelegates {
    var delegate: AddReviewDelegates!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addReviewClicked(_ sender: Any) {
        goToAddReview()
    }
    
    func goToAddReview() {
        delegate.goToAddReview()
    }
    
    
}
