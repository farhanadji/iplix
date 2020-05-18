//
//  AccountTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 09/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit
import Firebase

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height / 2
        if let user = Auth.auth().currentUser {
            titleLabel.text = user.displayName
            subtitleLabel.text = user.email
            if let avatar = user.photoURL?.absoluteString {
                avatarImage.sd_setImage(with: URL(string: avatar))
            }
        } else {
            titleLabel.text = K.text.accountLogin
            subtitleLabel.isHidden = true
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
