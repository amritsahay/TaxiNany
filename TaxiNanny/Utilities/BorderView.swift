//
//  BorderView.swift
//  Write Off Rocket
//
//  Created by ip-d on 22/08/18.
//  Copyright © 2018 Esferasoft Solutions. All rights reserved.
//

import UIKit

class BorderView: UIView {

    @IBInspectable var Color:UIColor = UIColor.white
    @IBInspectable var cornerEdge:CGFloat = 0
    @IBInspectable var witdh:CGFloat = 0
    @IBInspectable var isRounded:Bool = false
    
    @IBInspectable var isCardView:Bool = false
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if isCardView
        {   self.layer.masksToBounds = false
            self.layer.cornerRadius = 5.0
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
            self.layer.shadowRadius = 1
            self.layer.shadowOpacity = 1
            return
        } 
        
        self.layer.borderColor = Color.cgColor
        self.layer.borderWidth = witdh
        if isRounded
        {
            self.layer.cornerRadius = self.bounds.size.height/2
        }
        else
        {
            self.layer.cornerRadius = cornerEdge
        }
        self.layer.masksToBounds = true
        
       
    }


}
