//
//  selectedRiderCell.swift
//  TaxiNanny
//
//  Created by ip-d on 07/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol RiderTableViewButton{
    func OnClick(index: Int)
}


class selectedRiderCell: UITableViewCell,UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var txtdrop: SkyFloatingLabelTextField!
    @IBOutlet weak var txtpick: SkyFloatingLabelTextField!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var sincheckbtn: UIButton!
    @IBOutlet weak var soutcheckbtn: UIButton!
    @IBOutlet weak var setinstructionbtn: UIButton!
    @IBOutlet weak var Pickup: UIButton!
    @IBOutlet weak var DropLocation: UIButton!
    @IBOutlet weak var setprioritybtn: UIButton!
    @IBOutlet weak var instView: UIView!
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var pickupField: UITextField!
    @IBOutlet weak var drop: UITextField!
    @IBOutlet weak var soutcheckbox: UIImageView!
    @IBOutlet weak var sincheckbox: UIImageView!
    var celldeligate: RiderTableViewButton?
    var index: IndexPath?
    var id: String?
    let pickupPicker:UIPickerView = UIPickerView.init()
    var pid : Int = 0
    
    let DropPicker:UIPickerView = UIPickerView.init()
    var did : Int = 0
    
    var pcheck:Bool = true
    var dcheck:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
     
        pickupField.inputView = pickupPicker
        pickupPicker.dataSource = self
        pickupPicker.delegate = self
        
        drop.inputView = DropPicker
        DropPicker.dataSource = self
        DropPicker.delegate = self
        instView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
        // Configure the view for the selected state
    }
   
    @IBAction func setpriority(_ sender: Any) {
        priorityView.isHidden = false
        dropView.isHidden = false
        instView.isHidden = true
        setinstructionbtn.setTitleColor(.black, for: .normal)
        setprioritybtn.setTitleColor(.green, for: .normal)
    }
    
    @IBAction func setinstruction(_ sender: Any) {
         celldeligate?.OnClick(index: (index!.row))
         priorityView.isHidden = true
         dropView.isHidden = true
         instView.isHidden = false
        setinstructionbtn.setTitleColor(.green, for: .normal)
        setprioritybtn.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func sincheck(_ sender: Any) {
        if pcheck{
            self.sincheckbox.image = #imageLiteral(resourceName: "checkbox_checked")
            self.pcheck = false
        }else{
             self.sincheckbox.image = #imageLiteral(resourceName: "checkbox")
            self.pcheck = true
        }
    }
   
    @IBAction func soutcheck(_ sender: Any) {
        if dcheck{
            self.soutcheckbox.image = #imageLiteral(resourceName: "checkbox_checked")
            self.dcheck = false
        }else{
            self.soutcheckbox.image = #imageLiteral(resourceName: "checkbox")
            self.dcheck = true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        if (pickerView == pickupPicker){
             return 4
        }
        
        else if (pickerView == DropPicker){
             return 4
        }
        else{
             return 4
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         //return "Q" + " \(row+1)"
        
        if (pickerView == pickupPicker){
          return " \(row+1)"
        }
            
        else if (pickerView == DropPicker){
            return " \(row+1)"
        }
        else{
           return " \(row+1)"
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         // pickupField.text = " \(row+1)"
        // Qid = row+1
        if (pickerView == pickupPicker){
           pickupField.text = " \(row+1)"
        }
            
        else if (pickerView == DropPicker){
            drop.text = " \(row+1)"
        }
        else{
             //pickupField.text = " \(row+1)"
        }
        
    }
    
}
