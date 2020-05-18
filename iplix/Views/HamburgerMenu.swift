//
//  HamburgerMenu.swift
//  iplix
//
//  Created by Farhan Adji on 06/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class HamburgerMenu: UIView {
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var homeButton: UIView!
    @IBOutlet weak var productButton: UIView!
    @IBOutlet weak var orderButton: UIView!
    @IBOutlet weak var analyticsButton: UIView!
    @IBOutlet weak var homeTitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var analyticsTitle: UILabel!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dimBackground: UIView!
    @IBOutlet weak var accountButton: UIView!
    @IBOutlet weak var logoutButton: UIView!
    static let instance = HamburgerMenu()
    
    @IBOutlet weak var email: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("HamburgerMenu", owner: self, options: nil)
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        parentView.layer.cornerRadius = 40
        avatar.layer.cornerRadius = avatar.frame.height / 2
        avatar.contentMode = .scaleAspectFill
        changeState(selected: .home)
        homeButton.layer.cornerRadius = 10.0
        productButton.layer.cornerRadius = 10.0
        orderButton.layer.cornerRadius = 10.0
        analyticsButton.layer.cornerRadius = 10.0
        logoutButton.isHidden = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    enum MenuSelected {
        case home
        case product
        case order
        case analytics
    }
    
    func showMenu() {
        animationMenu()
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.last
        keyWindow?.addSubview(parentView)
        
    }
    
    func changeState(selected: MenuSelected) {
        homeButton.backgroundColor = UIColor.systemBackground
        homeTitle.font = UIFont.systemFont(ofSize: 17)
        orderButton.backgroundColor = UIColor.systemBackground
        orderTitle.font = UIFont.systemFont(ofSize: 17)
        productButton.backgroundColor = UIColor.systemBackground
        productTitle.font = UIFont.systemFont(ofSize: 17)
        analyticsButton.backgroundColor = UIColor.systemBackground
        analyticsTitle.font = UIFont.systemFont(ofSize: 17)
        
        switch selected {
        case .home:
            UIView.animate(withDuration: 0.25, animations: {
                self.homeButton.backgroundColor = UIColor.systemGray5
                self.homeTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
            })
        case .product:
            UIView.animate(withDuration: 0.25, animations: {
                self.productButton.backgroundColor = UIColor.systemGray5
                self.productTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
            })
        case .order:
            UIView.animate(withDuration: 0.25, animations: {
                self.orderButton.backgroundColor = UIColor.systemGray5
                self.orderTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
            })
        case .analytics:
            UIView.animate(withDuration: 0.25, animations: {
                self.analyticsButton.backgroundColor = UIColor.systemGray5
                self.analyticsTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
            })
        }
    }
    
    func animationMenu() {
        menuView.transform = CGAffineTransform(translationX: -400, y: 0)
        dimBackground.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.dimBackground.alpha = 1.0
            self.menuView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        print(menuView.frame)
    }
    
    @objc func homeTapped() {
        changeState(selected: .home)
        dismiss()
    }
    
    @objc func productTapped() {
        changeState(selected: .product)
        dismiss()
    }
    
    @objc func orderTapped() {
        changeState(selected: .order)
        dismiss()
    }
    
    @objc func analyticsTapped() {
        changeState(selected: .analytics)
        dismiss()
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dimBackground.alpha = 0
            self.menuView.transform = CGAffineTransform(translationX: -400, y: 0)
        }) { (_) in
            self.parentView.removeFromSuperview()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
