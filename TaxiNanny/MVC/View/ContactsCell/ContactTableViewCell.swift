//
//  ContactTableViewCell.swift
//  TaxiNanny
//
//  Created by Shashwat B on 18/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactimg: UIImageView!
    @IBOutlet weak var lblphoneno: UILabel!
    @IBOutlet weak var lblname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
