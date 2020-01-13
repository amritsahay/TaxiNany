//
//  PaymentTableViewCell.swift
//  TaxiNanny
//
//  Created by Shashwat B on 09/10/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit
protocol TableViewButton{
    func OnClick(index: Int, id: String)
}

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var btnselect: UIButton!
    @IBOutlet weak var lblexpirydate: UILabel!
    @IBOutlet weak var lblcardno: UILabel!
    @IBOutlet weak var lblcardname: UILabel!
    var celldeligate: TableViewButton?
    var index: IndexPath?
    var id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectcard(_ sender: Any) {
        celldeligate?.OnClick(index: (index!.row), id: id!)
    }
}
