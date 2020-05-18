//
//  HeaderTabCell.swift
//  iplix
//
//  Created by Farhan Adji on 18/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class HeaderTabCell: UICollectionViewCell {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var notificationCount: UILabel!
    var text: String! {
        didSet {
            headerTitle.text = text
            let label = UILabel()
            label.text = text
            label.sizeToFit()
            print(label.frame)
            
            headerTitle.widthAnchor.constraint(equalToConstant: label.frame.width + 20).isActive = true
        }
    }
    
    var count: String! {
        didSet {
            notificationCount.text = count
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print(headerTitle.frame.width)
        // Initialization code
        notificationView.layer.cornerRadius = 5.0
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        
        let countlbl = UILabel()
        countlbl.text = count
        countlbl.sizeToFit()
        
        
        notificationView.widthAnchor.constraint(equalToConstant: countlbl.frame.width + 20).isActive = true
        
    }
    
    //    func select(didSelect: Bool, activeColor: UIColor, inActiveColor: UIColor){
    //         indicator.backgroundColor = activeColor
    //         if didSelect {
    //             label.textColor = activeColor
    //             indicator.isHidden = false
    //         }else{
    //             label.textColor = inActiveColor
    //             indicator.isHidden = true
    //         }
    //     }
    
}
