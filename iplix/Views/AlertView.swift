//
//  AlertView.swift
//  iplix
//
//  Created by Farhan Adji on 05/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class AlertView: UIView {
    static let instance = AlertView()
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var btnOk: UIButton!
//    var target: UIViewController?
//    var instance =  AlertView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("new instance")
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        btnOk.backgroundColor = UIColor(named: "blibliPrimary")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    enum AlertType {
        case success
        case error
        case alert
        case information
    }
    
    func setAlert(title: String, message: String, alertType: AlertType) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        switch alertType {
        case .success:
            print("success")
            img.image = UIImage(systemName: "checkmark.circle.fill")
            img.tintColor = UIColor(named: "blibliLime")
        case .error:
            print("error")
            img.image = UIImage(systemName: "xmark.circle.fill")
            img.tintColor = UIColor(named: "blibliRed")
        case .alert:
            img.image = UIImage(systemName: "exclamationmark.triangle.fill")
            img.tintColor = UIColor(named: "blibliOrange")
        case .information:
            img.image = UIImage(systemName: "info.circle.fill")
            img.tintColor = UIColor(named: "blibliPrimary")
        }
        handleAnimationIntro()
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.last
        keyWindow?.addSubview(parentView)
    }
    
    func handleAnimationIntro() {
        alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
               alertView.alpha = 0
               
         UIView.animate(withDuration: 0.5) {
               self.alertView.alpha = 1
               self.alertView.transform = CGAffineTransform.identity
       }
    }
    
    @objc func hideAlert() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0
            self.parentView.alpha = 0
            self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in 
            self.parentView.removeFromSuperview()
        }
    }
}
