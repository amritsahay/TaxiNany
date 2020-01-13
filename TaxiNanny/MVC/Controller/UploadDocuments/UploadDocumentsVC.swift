//
//  UploadDocumentsVC.swift
//  TaxiNanny
//
//  Created by ip-d on 19/04/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit

class UploadDocumentsVC: UIViewController {
    
    @IBOutlet weak var listView: UITableView!
    
    var documents:[String] = ["Driver License","Vehicle Insurance","Vehicle Permit","Vehicle Registration"]
    
    var isOpen:[Bool] = [true,true,true,true]
    var documentsStatus:[Bool] = [false,false,false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // Mark - Button Method
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func next(_ sender: Any) {
        for i in 0..<documentsStatus.count
        {
            if documentsStatus[i] == false
            {
                openDocumentController(index: i)
                return
            }
        }
        
        
    }
    
    // Mark - other Methods
    func setUI() {
        listView.register(UINib.init(nibName:"DocumentCell", bundle:nil), forCellReuseIdentifier:"DocumentCell")
    }
}
extension UploadDocumentsVC // Controller functionality
{
    @objc func expand(button:UIButton) {
        let section = button.tag
        /*  isOpen[section] = !isOpen[section]
         listView.reloadData() */
        openDocumentController(index: section)
    }
    
    func openDocumentController(index:Int)
    {
        switch index {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"UploadDrivingLicenseVC") as! UploadDrivingLicenseVC
            self.navigationController?.pushViewController(vc, animated:true)
            
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"UploadVehicleInsuranceVC") as! UploadVehicleInsuranceVC
            self.navigationController?.pushViewController(vc, animated:true)
            break
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"UploadVehiclePermitVC") as! UploadVehiclePermitVC
            self.navigationController?.pushViewController(vc, animated:true)
            break
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier:"UploadVehicleRegistrationVC") as! UploadVehicleRegistrationVC
            self.navigationController?.pushViewController(vc, animated:true)
            break
        default:
            break
        }
    }
    
}

extension UploadDocumentsVC:UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return documents.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOpen[section]
        {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"DocumentCell", for:indexPath) as! DocumentCell
        cell.selectionStyle = .none
        cell.message.text = "Step \(indexPath.row + 1): " + "Please upload your " + documents[indexPath.section] + "."
        if documentsStatus[indexPath.section]
        {
            cell.mark.isHidden = false
        }
        else
        {
            cell.mark.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DocumentView.init()
        header.step.text = "Step \(section + 1):"
        header.title.text = documents[section]
        header.expand.addTarget(self, action: #selector(expand(button:)), for:.touchUpInside)
        header.expand.tag = section
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63
    }
}

extension UploadDocumentsVC:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDocumentController(index: indexPath.section)
        // documentsStatus[indexPath.section] = !documentsStatus[indexPath.section]
        //tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension UploadDocumentsVC // update documen status
{
    func updateDocumentStatus(document_name:String)
    {
        switch document_name {
        case "Driver License":
            documentsStatus[0] = true
            break
        case "Vehicle Insurance":
            documentsStatus[1] = true
            break
        case "Vehicle Permit":
            documentsStatus[2] = true
            break
        case "Vehicle Registration":
            documentsStatus[3] = true
            break
        default:
            break
        }
        listView.reloadData()
    }
}

