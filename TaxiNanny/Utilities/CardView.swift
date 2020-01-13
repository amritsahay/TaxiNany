//
//  CardView.swift
//  TaxiNanny
//
//  Created by ip-d on 24/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
//    @IBInspectable var cornerRadius: CGFloat = 2
//    
//    @IBInspectable var shadowOffsetWidth: Int = 0
//    @IBInspectable var shadowOffsetHeight: Int = 3
//    @IBInspectable var shadowColor: UIColor? = UIColor.gray
//    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
//        layer.cornerRadius = cornerRadius
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//
//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
    }
    
}
