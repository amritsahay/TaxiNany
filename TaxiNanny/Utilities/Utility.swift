//
//  Utility.swift
//  Basic Humanity
//
//  Created by ip-d on 14/12/17.
//  Copyright © 2017 Esferasoft Solutions. All rights reserved.
//
//763a68cad9f522f3d0bf15a4500b8109ace8d33b
//4fad12e95a5c60f57bacc6e4ce8f149031fa9b0d
import UIKit
import MaterialComponents.MaterialSnackbar
import NVActivityIndicatorView
import SDWebImage
import AVFoundation


class Utility: NSObject {
    static let shared:Utility = Utility()
    
    
    func startProgress(message:String) {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
            NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
        }
        
    }
    
    func stopProgress() {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
    
    //Mark: show snackbar Message
    func showSnackBarMessage(message:String){
        DispatchQueue.main.async {
            let snackbarMessage = MDCSnackbarMessage()
            snackbarMessage.text = message
            MDCSnackbarManager.show(snackbarMessage)
        }

    }
    
    
    
}

public extension Date {
    
    /*
     let yesterday = Date(timeInterval: -86400, since: Date())
     let tomorrow = Date(timeInterval: 86400, since: Date())
     let diff = tomorrow.interval(ofComponent: .day, fromDate: yesterday)
     */
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func age(birthday:Date) -> Int
    {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }
}
public extension UIView {
    
    public enum ViewSide {
        case top
        case right
        case bottom
        case left
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
        self.layoutIfNeeded()
    }
}

public extension String {
    static let shortDateUS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .short
        return formatter
    }()
    var shortDateUS: Date? {
        return String.shortDateUS.date(from: self)
    }
    
}
