//
//  VehicleTypeViewCell.swift
//  TaxiNanny
//
//  Created by ip-d on 26/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class VehicleTypeViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
