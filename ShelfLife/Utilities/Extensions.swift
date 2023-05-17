//
//  Extensions.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import UIKit

extension UIView {
    func updateWidth(newWidth: CGFloat) {
        let rect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newWidth, height: self.frame.size.height)
        self.frame = rect
    }
    
    func borderAndCorner(cornerRadious: CGFloat, borderWidth: CGFloat, borderColor: UIColor?) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

