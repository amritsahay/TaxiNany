//
//  RiderCell.swift
//  TaxiNanny
//
//  Created by ip-d on 15/05/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class RiderCell: UITableViewCell {

    @IBOutlet weak var photo_view: UIImageView!
    
    @IBOutlet weak var rider_name: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
