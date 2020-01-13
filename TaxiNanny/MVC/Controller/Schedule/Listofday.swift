//
//  Listofday.swift
//  TaxiNanny
//
//  Created by ip-d on 11/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class Listofday: UIViewController {

    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var list_view: UITableView!
    var currentday:String = ""
    var endday:String = ""
    var all:Bool = false
    let datePicker = UIDatePicker()
    var sel:Bool = false
    var vardate:String = ""
    var vartime:String = ""
    var arrWeek = ["0":"Sunday","1":"Monday","2":"Tuesday","3":"Wednesday","4":"Thursday","5":"Friday","6":"Saturday"]
    var weeks = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var start = 0
    var end = 6
    var remain:Int = 0
    var selectedDate = [String]()
    var selectcolor = ["0":"","1":"","2":"","3":"","4":"","5":"","6":""]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in weeks{
            selectedDate.append(i)
        }
        setUI()
    }
    
    func setUI()
    {
        list_view.register(UINib(nibName:"WeekViewCell", bundle:nil), forCellReuseIdentifier:"WeekViewCell")
        self.list_view.separatorStyle = UITableViewCell.SeparatorStyle.none
        showDatePicker()
    }
    
    // Marks - Button Method
    
    @IBAction func `continue`(_ sender: Any) {
        if date.text == ""{
            Utility.shared.showSnackBarMessage(message: "Please Choose end date")
            return
        }
        var check = true
        for i in 0..<self.selectcolor.count{
            if self.selectcolor[String(i)] != ""{
                check = false
                break
            }
        }
        if check{
            Utility.shared.showSnackBarMessage(message: "Please Recurring days")
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Pickup_and_droupoffVC") as! Pickup_and_droupoffVC
        vc.vardate = self.vardate
        vc.vartime = self.vartime
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func back(_ sender: Any) {
        // self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.minimumDate = .today()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        date.inputAccessoryView = toolbar
        date.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        //Select date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        formatter.dateFormat = "yyyyMMdd"
        let enddate = formatter.string(from: datePicker.date)
        formatter.dateFormat = "EEEE"
        endday = formatter.string(from: datePicker.date)
        print(endday)
        
        //today
        let date = Date()
        formatter.dateFormat = "yyyyMMdd"
        let currentdate = formatter.string(from: date)
        formatter.dateFormat = "EEEE"
        currentday = formatter.string(from: date)
        self.remain = Int(enddate)! - Int(currentdate)!
        if self.remain > 7 {
            self.all = true
        }else{
            self.all = false
            for i in arrWeek{
                if self.currentday == i.value{
                    self.start = Int(i.key)!
                }
                if self.endday == i.value{
                    self.end = Int(i.key)!
                }
            }
        }
        self.selectedDate.removeAll()
        for i in start...end{
            self.selectedDate.append(weeks[i])
        }
        self.list_view.reloadData()
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }


}

extension Listofday:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WeekViewCell", for: indexPath) as! WeekViewCell
        cell.title.text = weeks[indexPath.row]
        cell.cardview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        if all{
             cell.cardview.backgroundColor = .white
        }else{
            for i in 0..<self.selectedDate.count{
                if self.selectedDate[i] == arrWeek["\(indexPath.row)"]{
                     cell.cardview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                     break
                }
            }
            if self.selectcolor[String(indexPath.row)] != ""{
                cell.checkimage.image = #imageLiteral(resourceName: "select")
            }else{
                cell.checkimage.image = nil
            }
//            if self.sel{
//                cell.cardview.backgroundColor = .white
//            }else{
//                cell.cardview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            }
//            if currentday == arrWeek["\(indexPath.row)"]{
//                cell.cardview.backgroundColor = .white
//                self.sel = true
//            }else{
//                 cell.cardview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            }
//            if endday == arrWeek["\(indexPath.row)"]{
//                cell.cardview.backgroundColor = .white
//                self.sel = false
//            }
        }
        
        return cell
   }

}

extension Listofday:UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        for i in 0..<self.selectedDate.count{
            if self.selectedDate[i] == arrWeek["\(indexPath.row)"]{
                if self.selectcolor[String(indexPath.row)] == ""{
                    self.selectcolor[String(indexPath.row)] = self.weeks[indexPath.row]
                }else{
                    self.selectcolor[String(indexPath.row)] = ""
                }
                break
            }
        }
       
        self.list_view.reloadData()
        
        
    }
}
