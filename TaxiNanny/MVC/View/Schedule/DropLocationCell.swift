//
//  DropLocationCell.swift
//  TaxiNanny
//
//  Created by ip-d on 10/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class DropLocationCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var description1: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
          self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
