//
//  BottomSheetView.swift
//  iplix
//
//  Created by Farhan Adji on 08/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class BottomSheetView: UIView {
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var notch: UIView!
    @IBOutlet weak var dimBackground: UIView!
    @IBOutlet weak var sheetView: UIView!
    
    static let instance = BottomSheetView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("BottomSheetView", owner: self, options: nil)
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        notch.layer.cornerRadius = 5
        sheetView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func show() {
        animationShow()
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.last
        keyWindow?.addSubview(parentView)
    }
    
    func animationShow() {
        notch.transform = CGAffineTransform(translationX: 0, y: 400)
        sheetView.transform = CGAffineTransform(translationX: 0, y: 400)
        dimBackground.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.notch.transform = CGAffineTransform(translationX: 0, y: 0)
            self.sheetView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.dimBackground.alpha = 1.0
        })
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.notch.transform = CGAffineTransform(translationX: 0, y: 400)
            self.sheetView.transform = CGAffineTransform(translationX: 0, y: 400)
            self.dimBackground.alpha = 0.0
        }) { (_) in
            self.parentView.removeFromSuperview()
        }
    }
}

extension UIView {
   func roundCorners(corners:CACornerMask, radius: CGFloat) {
      self.layer.cornerRadius = radius
      self.layer.maskedCorners = corners
   }
}
