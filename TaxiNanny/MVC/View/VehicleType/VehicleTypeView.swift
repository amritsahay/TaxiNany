//
//  VehicleTypeView.swift
//  TaxiNanny
//
//  Created by ip-d on 25/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class VehicleTypeView: UIView {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var frame_view: UIView!
    @IBOutlet weak var button: UIButton!
  
    @IBOutlet weak var car_name: UILabel!
    
    @IBOutlet weak var car_image: UIImageView!
    
    @IBOutlet weak var check: UIImageView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("VehicleTypeView", owner: self, options:nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    override func layoutSubviews() {
        frame_view.layer.cornerRadius = 5.0
        frame_view.layer.shadowColor = UIColor.black.cgColor
        frame_view.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        frame_view.layer.shadowRadius = 1
        frame_view.layer.shadowOpacity = 0.5
    }

}
