//
//  PaymentVC.swift
//  TaxiNanny
//
//  Created by ip-d on 17/06/19.
//  Copyright © 2019 TaxiNanny. All rights reserved.
//

import UIKit
import Stripe

class PaymentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //        let addCardViewController = STPAddCardViewController()
        //        addCardViewController.delegate = self
        //        // STPAddCardViewController must be shown inside a UINavigationController.
        //        let navigationController = UINavigationController(rootViewController: addCardViewController)
        //        self.present(navigationController, animated: true, completion: nil)
    }
    
    // payment
    
    /**
     *  Called when the user cancels adding a card. You should dismiss (or pop) the view controller at this point.
     *
     *  @param addCardViewController the view controller that has been cancelled
     */
    public func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     *  This is called when the user successfully adds a card and tokenizes it with Stripe. You should send the token to your backend to store it on a customer, and then call the provided `completion` block when that call is finished. If an error occurred while talking to your backend, call `completion(error)`, otherwise, dismiss (or pop) the view controller.
     *
     *  @param addCardViewController the view controller that successfully created a token
     *  @param token                 the Stripe token that was created. @see STPToken
     *  @param completion            call this callback when you're done sending the token to your backend
     */
    public func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        print("token===>\(token)")
        print("token===>\(String(describing: token.card?.cardId))")
        print("token===>\(String(describing: token.card?.label))") //("Visa 7648"), ("MasterCard 1394"), ("American Express 1257"), ("Discover 9621")
        print("tokenExpMonth===>\(String(describing: token.card?.expMonth))")
        print("tokenExpYear===>\(String(describing: token.card?.expYear))")
        
        print("added card")
        
        STPCardValidator.validationState(forExpirationYear: String(describing: token.card?.expYear), inMonth: String(describing: token.card?.expMonth))
        
        self.dismiss(animated: true, completion: nil)
    }

}
