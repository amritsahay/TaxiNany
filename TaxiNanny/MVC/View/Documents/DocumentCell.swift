//
//  DocumentCell.swift
//  TaxiNanny
//
//  Created by ip-d on 19/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var mark: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
