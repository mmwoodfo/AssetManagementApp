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
    
    private let tempAdapterArray = ["meg","you","need","to","finish","this"]

    //Outlets to handle passing data to the model
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var asuField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var reasonField: UITextField!
    
    
    @IBOutlet weak var SuccessLabel: UILabel!
    
    @IBOutlet weak var dateHolder: UILabel!
    
    
    @IBOutlet weak var InputTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    let adapterPicker = UIPickerView()
    
    var selectedAdapter: String = ""
    
    
    override func viewDidLoad() {
        
         super.viewDidLoad()
        
        //To get current date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        let formattedDate = format.string(from: date)
        dateHolder.text = formattedDate
        
        //Date Picker setup
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(CheckoutViewController.dateChanged(datePicker:)), for: .valueChanged)
        InputTextField.inputView = datePicker
        

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.viewTapped(gestureRecognixer:)))
        view.addGestureRecognizer(tapGesture)
        
        SuccessLabel.isHidden = true
        
       

        // Do any additional setup after loading the view.
        
    }
    
    //Function that allows UI elements to close when tapped outside
    @objc func viewTapped(gestureRecognixer: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYY"
        InputTextField.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
        
    }
    


    @IBAction func CheckOutItem(_ sender: Any) {
        
        let name: String = nameField.text!
        let asuID: String = asuField.text!
        let email: String = emailField.text!
        let phone: String = phoneField.text!
        let reason: String = reasonField.text!
        let expectedReturnDate:String = dateHolder.text!
        
        
        /*Validate that important information is not empty**/
        if(name == "" || asuID == "" || email == "" || reason == ""){
            displayAlert(givenTitle:"Missing information", givenMessage:"Please fill out all required fields")
        }else{
            let checkedoutItem:CheckedoutItem = CheckedoutItem(name: name, asuriteId: asuID, email: email, phoneNumber: phone, reason: reason, expectedReturnDate: expectedReturnDate, adaptorName: selectedAdapter)
            
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


