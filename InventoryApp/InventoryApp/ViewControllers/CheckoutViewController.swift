//
//  CheckoutViewController.swift
//  InventoryApp
//
//  Created by Meghan on 10/23/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit
weak var field: UITextField!


class CheckoutViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var asuField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var reasonField: UITextField!
    @IBOutlet weak var adapterType: UITextField!
    
    @IBOutlet weak var SuccessLabel: UILabel!
    
    override func viewDidLoad() {
        
        SuccessLabel.isHidden = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func CheckOutItem(_ sender: Any) {
        
        let name: String = nameField.text!
        let asuID: String = asuField.text!
        let email: String = emailField.text!
        let phone: String = phoneField.text!
        let reason: String = reasonField.text!
        let expectedReturnDate:String = ""
        let adaptorName:String = adapterType.text!
        
        /*Validate that important information is not empty**/
        if(name == "" || asuID == "" || email == "" || reason == ""){
            displayAlert(givenTitle:"Missing information", givenMessage:"Please fill out all required fields")
        }else{
            let checkedoutItem:CheckedoutItem = CheckedoutItem(name: name, asuriteId: asuID, email: email, phoneNumber: phone, reason: reason, expectedReturnDate: expectedReturnDate, adaptorName: adaptorName)
            
            /*If important information is not empty add to core data & check if method added succussfully*/
            if(addCheckoutObjectToCoreData(checkedoutItem: checkedoutItem)){
                clearUI()
                SuccessLabel.isHidden = false
            }else{
                displayAlert(givenTitle:"Something went wrong", givenMessage:"The item could not be added to the list of checkedout consumables")
            }
        }
    
        
    }
    
    
    @IBAction func ClearFields(_ sender: Any) {
        clearUI()
    }
    
    /*
     addCheckedoutObjectToCoreData adds a passed item to core data and either returns true or false depending on if the item was successfully added or not
     */
    func addCheckoutObjectToCoreData(checkedoutItem:CheckedoutItem) -> Bool{
        return false
    }
    
    /*displayAlert displays an alert to the UI with a given title and given message. This alert is only used as a popup to notify the user of something important, usually an error*/
    func displayAlert(givenTitle:String, givenMessage:String){
        let alert = UIAlertController(title: givenTitle, message: givenMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    /*clearUI is used to clear all of the text fields in the view controller**/
    func clearUI(){
        for view in self.view.subviews{
            if let textField = view as? UITextField{
                textField.text = ""
            }
        }
    }

}
