//
//  LogoutTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 13/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

protocol LogoutDelegate {
    func logout()
}

class LogoutTableViewCell: UITableViewCell, LogoutDelegate {
    @IBOutlet weak var logoutBtn: UIButton!
    var delegate: LogoutDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.logout()
    }
    
    func logout() {
        delegate.logout()
    }
    
}
