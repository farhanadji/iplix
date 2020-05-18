//
//  StatusChip.swift
//  iplix
//
//  Created by Farhan Adji on 15/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

enum StatusList {
    case new
    case pickup_time_filled
    case waiting_for_pickup
    case already_picked_up
    case already_settled
    case delivered
    case canceled
    case delivery_failed
}

enum ColorState {
    case blue
    case orange
    case red
    case lime
}

private let blue = UIColor(named: "blibliPrimary")
private let orange = UIColor(named: "blibliOrange")
private let red = UIColor(named: "blibliRed")
private let lime = UIColor(named: "blibliLime")

class StatusChip: UIView {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewFromXib = Bundle.main.loadNibNamed("StatusChip", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = bounds
        viewFromXib.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(viewFromXib)
        backgroundView.layer.cornerRadius = 10
    }
    
    func setCustomChip(title: String, color: ColorState) {
        switch color {
        case .blue:
            backgroundView.backgroundColor = blue
        case .orange:
            backgroundView.backgroundColor = orange
        case .lime:
            backgroundView.backgroundColor = lime
        case .red:
            backgroundView.backgroundColor = red
        }
        
        statusLabel.text = title
        statusLabel.sizeToFit()
        self.frame = CGRect(x: 0, y: 0, width: statusLabel.frame.width + 20, height: 20)
    }
    
    func setStatus(status: StatusList) {
        var text = ""
        switch status {
        case .new:
            text = "New"
            backgroundView.backgroundColor = blue
        case .pickup_time_filled:
            text = "Pickup time filled"
            backgroundView.backgroundColor = orange
        case .waiting_for_pickup:
            backgroundView.backgroundColor = orange
            text = "Waiting for pickup"
        case .already_picked_up:
            backgroundView.backgroundColor = orange
            text = "Already picked up"
        case .already_settled:
            backgroundView.backgroundColor = lime
            text = "Already settled"
        case .delivered:
            backgroundView.backgroundColor = lime
            text = "Delivered"
        case .canceled:
            backgroundView.backgroundColor = red
            text = "Canceled"
        case .delivery_failed:
            backgroundView.backgroundColor = red
            text = "Delivery failed"
        }
        statusLabel.text = text
        statusLabel.sizeToFit()
        self.frame = CGRect(x: 0, y: 0, width: statusLabel.frame.width + 20, height: 20)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
