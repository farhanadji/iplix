//
//  NameProfileTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 22/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

protocol NameEditDelegate {
    func getNameEdited(name: String)
}
class NameProfileTableViewCell: UITableViewCell {

   
    @IBOutlet weak var nameTextField: UITextField!
    var delegate: NameEditDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func textChanged(_ sender: UITextField) {
        delegate?.getNameEdited(name: sender.text!)
    }
//    @IBAction func editingChanged(_ sender: UITextField) {
//        delegate?.getNameEdited(name: sender.text!)
//    }
//
}
