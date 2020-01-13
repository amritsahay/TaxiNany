//
//  SlideMenuCell.swift
//  Luggage
//
//  Created by esferasoft on 02/05/19.
//  Copyright © 2019 esferasoft. All rights reserved.
//

import UIKit

class SlideMenuCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
