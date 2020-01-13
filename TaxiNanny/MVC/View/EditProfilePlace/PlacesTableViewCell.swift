//
//  PlacesTableViewCell.swift
//  TaxiNanny
//
//  Created by Shashwat B on 22/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit

protocol TableViewPlace{
    func OnClick(index: Int, id: String)
}

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var lblsubloc: UILabel!
    @IBOutlet weak var lbllocation: UILabel!
    var celldeligate: TableViewPlace?
    var index: IndexPath?
    var id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func edit(_ sender: Any) {
        celldeligate?.OnClick(index: (index!.row), id: id!)
    }
}
