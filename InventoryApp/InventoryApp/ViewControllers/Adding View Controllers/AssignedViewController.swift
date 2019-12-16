//
//  AssignedViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/22/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class AssignedViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    private var methods:MethodsForController = MethodsForController()
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    var assigned = [Assigned]()
    
    private var savedObject: Bool = false
    private var tempAdapterArray = [String]()
    private var datePicker: UIDatePicker?
    private let adapterPicker = UIPickerView()
    private var activeAdapterTextField = 0
    private var selectedAdapter: String = ""
    
    //Outlets to handle passing data to the model
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var asuField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var reasonField: UITextField!
    @IBOutlet weak var adapterSelector: UITextField!
    @IBOutlet weak var SuccessLabel: UILabel!
    @IBOutlet weak var dateHolder: UILabel!
    @IBOutlet weak var btnAssign: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var ticketNumber: UITextField!
    
    //------------------------ VIEW DID LOAD FUNCTION --------------------------//
    override func viewDidLoad(){
        super.viewDidLoad()
        //set button designs
        btnAssign.layer.cornerRadius = 10
        btnExit.layer.cornerRadius = 10
        
        //Set adaptors
        tempAdapterArray = fireBaseMethods.getAdapterTypes()
        
        //To get current date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy"
        let formattedDate = format.string(from: date)
        dateHolder.text = formattedDate
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AssignedViewController.viewTapped(gestureRecognixer:)))
        view.addGestureRecognizer(tapGesture)
        
        // Stuff for Adapter selector
        adapterSelector.delegate = self
        createPickerView()
        
        SuccessLabel.isHidden = true
    }
    
    //---------------------------- EXIT ASSIGNED PAGE --------------------------------//
    @IBAction func ExitAssignedPage(_ sender: Any) {
        savedObject = true
    }
    
    //------------------------ ASSIGN ITEM BUTTON PRESSED ---------------------------//
    @IBAction func AssignItem(_ sender: Any){
        /*Validate that important information is not empty**/
        if(nameField.text == "" ||
            asuField.text == "" ||
            reasonField.text == "" ||
            adapterSelector.text == ""){
            self.present(methods.displayAlert(givenTitle: "Invalid Information", givenMessage: ""), animated: true)
        }
            
        else if !methods.checkPhoneNumberWithDashes(phoneNumber: phoneField.text ?? "") || !methods.checkEmail(email: emailField.text ?? ""){
            self.present(methods.displayAlert(givenTitle: "Invalid Phone or Email", givenMessage: ""), animated: true)
            
        }else{
            fireBaseMethods.addAssignedToFirebase(name: nameField.text ?? "", asuriteId: asuField.text ?? "", email: emailField.text ?? "", phoneNumber: phoneField.text ?? "", adaptorType: adapterSelector.text ?? "", loanedDate: dateHolder.text ?? "", ticketNumber: ticketNumber.text ?? "", reason: reasonField.text ?? "")
            savedObject = true
        }
    }
    
    //------------------------------- PREPARE FOR UNWIND SEGUE --------------------------------------//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let destinationViewControler = segue.destination as! ListOfAssignedItemsViewController
        destinationViewControler.assignedTable.reloadData()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(savedObject){
            return true
        }else{
            return false
        }
    }
    
    //------------------------------ CLEAR FIELDS & DISPLAY ERROR ALERTS ------------------------------//
    @IBAction func ClearFields(_ sender: Any){
        methods.clearUI(viewController: self)
    }
    
    //------------------- VIEW TAPPED FUNCTION - CLOSE UI ELEMENTS ---------------------//
    //Function that allows UI elements to close when tapped outside
    @objc func viewTapped(gestureRecognixer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    //------------------------------- ADAPTER PICKER SET UP --------------------------------------//
    func createPickerView(){
        adapterPicker.delegate = self
        adapterPicker.delegate?.pickerView?(adapterPicker, didSelectRow: 0, inComponent: 0)
        adapterSelector.inputView = adapterPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return tempAdapterArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return tempAdapterArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        adapterSelector.text =  tempAdapterArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        return 200.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 60.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        switch activeAdapterTextField{
        case 1:
            var label:UILabel
            
            if let v = view as? UILabel{
                label = v
            }
            else{
                label = UILabel()
            }
            
            label.textColor = UIColor.black
            label.textAlignment = .left
            label.font = UIFont(name: "Helvetica", size: 16)
            
            label.text = tempAdapterArray[row]
            
            return label
        default:
            return UILabel()
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeAdapterTextField = 1
        adapterPicker.reloadAllComponents()
    }
    
}
