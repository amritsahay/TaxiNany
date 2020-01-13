//
//  RiderCollectionViewCell.swift
//  TaxiNanny
//
//  Created by ip-d on 14/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class RiderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var estimatedTime: UILabel!
    @IBOutlet weak var riderpic: UIImageView!
    @IBOutlet weak var estimatePrice: UILabel!
    @IBOutlet weak var ridername: UILabel!
    @IBOutlet weak var estimatedDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
