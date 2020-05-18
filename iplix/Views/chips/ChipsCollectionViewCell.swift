//
//  ChipsCollectionViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 12/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class ChipsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var chipView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        chipView.layer.cornerRadius = 15.0
        chipView.layer.borderWidth = 1.0
        chipView.layer.borderColor = UIColor.systemGray3.cgColor
        titleLabel.textColor = UIColor(named: "blibliPrimary")
    }
    
    func select(didSelect: Bool){
           if didSelect {
            titleLabel.textColor = UIColor.white
            chipView.backgroundColor = UIColor(named: "blibliPrimary")
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
           }else{
            titleLabel.textColor = UIColor(named: "blibliPrimary")
            chipView.backgroundColor = UIColor.white
            titleLabel.font = UIFont.systemFont(ofSize: 16.0)
           }
       }
}
