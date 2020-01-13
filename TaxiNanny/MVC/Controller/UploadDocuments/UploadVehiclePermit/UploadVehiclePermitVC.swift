//
//  UploadVehiclePermitVC.swift
//  TaxiNanny
//
//  Created by ip-d on 01/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UploadVehiclePermitVC: UIViewController {
    @IBOutlet weak var filename: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func choose(_ sender: Any) {
       // selectPhotoActionSheet()
        pdfFile()
    }
    
    @IBAction func submit(_ sender: Any) {
        if validation()
        {
            //updateBack()
            pdfFile()
        }
    }
    
    func validation() -> Bool
    {
        if (filename.text?.isBlank)!
        {
            return false
        }
        
        return true
    }
    
    func pdfFile(){

        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data","com.adobe.pdf"], in: .import)
        //Call Delegate
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
        
//        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.text"], in: UIDocumentPickerMode.import)
//        documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    func updateBack()
    {
        if let viewControllers = self.navigationController?.viewControllers
        {
            for viewController in viewControllers
            {
                if viewController.isKind(of:UploadDocumentsVC.self)
                {
                    let uploadDocumentVC = viewController as! UploadDocumentsVC
                    uploadDocumentVC.updateDocumentStatus(document_name:"Vehicle Permit")
                    self.navigationController?.popToViewController(uploadDocumentVC, animated:true)
                    break
                }
            }
            
        }
        
    }
    
    func selectPhotoActionSheet()
    {
        let alertViewController = UIAlertController(title:"Rider Photo", message: "Please select an option.", preferredStyle: .actionSheet)
        
        let cameraAlertAction = UIAlertAction(title:"Take Photo", style: .default) { (sender) in
            self.openDeviceCamera()
            alertViewController.dismiss(animated:true, completion: nil)
        }
        alertViewController.addAction(cameraAlertAction)
        
        let libraryAlertAction = UIAlertAction(title: "Photos Library", style:.default) { (sender) in
            self.openDevicePhotoGallary()
            alertViewController.dismiss(animated: true, completion:nil)
        }
        alertViewController.addAction(libraryAlertAction)
        
        let cancelAlertAction = UIAlertAction(title:"Cancel", style: .cancel) { (sender) in
            alertViewController.dismiss(animated:true, completion:nil)
        }
        alertViewController.addAction(cancelAlertAction)
        
        self.present(alertViewController, animated: true, completion:nil)
    }
    
    func openDeviceCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            Utility.shared.showSnackBarMessage(message:"Sorry,Camera service not available.")
        }
        
    }
    
    func openDevicePhotoGallary()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            Utility.shared.showSnackBarMessage(message:"Sorry,Photos Library service not available.")
        }
    }
    
}

extension UploadVehiclePermitVC:UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                self.filename.text = "document file"
            }
            
        }
        else if picker.sourceType == .photoLibrary
        {
            if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
            {
                let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                self.filename.text = "document file"
            }
        }
        picker.dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UploadVehiclePermitVC:UINavigationControllerDelegate
{
    
}


// webseevice
extension UploadVehiclePermitVC
{
    func UploadVehiclePermitApi(urlString:URL) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let pdfData = try! Data(contentsOf: urlString.asURL())
        let data : Data = pdfData
        
        let url = "http://178.128.116.149/taxinanny1/public/api/addvehiclepermitdriver"
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(("2".data(using: String.Encoding.utf8))!, withName: "driver_id")
                
                multipartFormData.append(("1".data(using: String.Encoding.utf8))!, withName: "vehicle_id")
                
                multipartFormData.append(data, withName: "vehicle_permit_document")
        },
            to: url,
            method:.post,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        // Utility.shared.stopProgress()
                        print("Validation Successful")
                        let jsonString = response.value?.replacingOccurrences(of:"mu-plugins/query-monitor/wp-content/db.php", with:"")
                        let json = JSON.init(parseJSON:jsonString ?? "{}")
                        let response = json.dictionary
                        let status = response?["status"]?.stringValue
                        if status == "ok"
                        {
                            self.updateBack()
                        }
                        else
                        {
                            //                            Utility.shared.showSnackBarMessage(message:(response?["error"]?.stringValue)!)
                        }
                        
                    }
                case .failure(let encodingError):
                    //Utility.shared.stopProgress()
                    print(encodingError)
                    Utility.shared.showSnackBarMessage(message:encodingError.localizedDescription)
                }
        }
        )
        
    }
    
}

extension UploadVehiclePermitVC:UIDocumentMenuDelegate,UIDocumentPickerDelegate
{

public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let myURL = urls.first else {
        return
    }
    print("import result : \(myURL)")
    UploadVehiclePermitApi(urlString:myURL )
    
}


public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
    documentPicker.delegate = self
    present(documentPicker, animated: true, completion: nil)
}


func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    print("view was cancelled")
    dismiss(animated: true, completion: nil)
    }

}
