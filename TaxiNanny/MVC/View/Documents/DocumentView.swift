//
//  DocumentView.swift
//  TaxiNanny
//
//  Created by ip-d on 19/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class DocumentView: UIView {
    
    @IBOutlet weak var contentView: UIView!
  
    @IBOutlet weak var frame_view: UIView!
    @IBOutlet weak var step: UILabel!
    @IBOutlet weak var title: UILabel!
  
    @IBOutlet weak var expand: UIButton!
    
    @IBOutlet weak var arrow_image: UIImageView!
    
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
        Bundle.main.loadNibNamed("DocumentView", owner: self, options:nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    @IBAction func expandAction(_ sender: Any) {
    
    }
    
    override func layoutSubviews() {
        frame_view.layer.cornerRadius = 5.0
        frame_view.layer.shadowColor = UIColor.black.cgColor
        frame_view.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        frame_view.layer.shadowRadius = 1
        frame_view.layer.shadowOpacity = 0.5
    }
}
