//
//  ButtonView.swift
//  TaxiNanny
//
//  Created by Shashwat B on 04/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import Foundation
import ARKit

@IBDesignable extension UIButton{
    @IBInspectable var borderWidth: CGFloat{
        set{
            layer.borderWidth = newValue
        }
        get{
            return layer.borderWidth
        }
    }
    
    @IBInspectable var crnrRadius: CGFloat {
        set{
            layer.cornerRadius = newValue
        }
        get{
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor? {
        set{
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get{
            guard let color = layer.borderColor else { return nil}
            return UIColor(cgColor: color)
        }
    }
    
}
