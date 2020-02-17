//
//  CheckoutViewController.swift
//  InventoryApp
//
//  Created by Meghan on 10/23/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit
import AnyFormatKit

class CheckoutViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    private var methods:MethodsForController = MethodsForController()
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    var checkedout = [CheckedOut]()
    var reviewed = false
    
    private var tempAdapterArray = [String]()
    private let adapterPicker = UIPickerView()
    private var selectedAdapter: String = ""
    private var activeTextField = 0
    private var datePicker: UIDatePicker?
    private var savedObject:Bool = false
    
    //signiture
    private var startingPoint: CGPoint!
    private var touchPoint: CGPoint!
    private var path:UIBezierPath!
    private var signiture:UIImage!
    
    //Outlets to handle passing data to the model
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var asuField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var reasonField: UITextField!
    @IBOutlet weak var adapterSelector: UITextField!
    @IBOutlet weak var countField: UITextField!
    @IBOutlet weak var SuccessLabel: UILabel!
    @IBOutlet weak var dateHolder: UILabel!
    @IBOutlet weak var returnDateField: UITextField!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var ticketNumber: UITextField!
    @IBOutlet weak var signitureField: UIImageView!
    
    //------------------------ VIEW DID LOAD FUNCTION --------------------------//
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //set button designs
        btnCheckout.layer.cornerRadius = 10
        btnExit.layer.cornerRadius = 10
        
        //Set adaptors
        tempAdapterArray.append("")
        fireBaseMethods.getAdapterTypes { [weak self] type in
            self?.tempAdapterArray.append(type)
            DispatchQueue.main.async {
                // Stuff for Adapter selector
                self?.adapterSelector.delegate = self
                self?.createPickerView()
            }
        }
        
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
        returnDateField.inputView = datePicker
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.viewTapped(gestureRecognixer:)))
        view.addGestureRecognizer(tapGesture)
        
        SuccessLabel.isHidden = true
    }
    
    @IBAction func setDate(_ sender: Any) {
        if(returnDateField.text == ""){
            returnDateField.text = dateHolder.text
        }
    }
    
    @IBAction func populateEmail(_ sender: Any) {
        if(asuField.text != "" && asuField != nil){
            emailField.text = "\(asuField.text!)@asu.edu"
        }
    }
    
    @IBAction func stoppedTyping(_ sender: UITextField) {
        let phoneFormatter = DefaultTextFormatter(textPattern: "###-###-####")
        if(!((phoneField.text ?? "").contains("-"))){
            phoneField.text = phoneFormatter.format(phoneField.text)
        }
    }
    
    //----------------------------- EXIT CHECKOUT PAGE --------------------------------//
    @IBAction func ExitCheckoutPage(_ sender: Any) {
        savedObject = true
    }
    
    //------------------------ CHECKOUT ITEM BUTTON PRESSED ---------------------------//
    @IBAction func CheckOutItem(_ sender: Any){
        /*Validate that important information is not empty**/
        if(
            nameField.text == "" ||
                asuField.text == "" ||
                reasonField.text == "" ||
                adapterSelector.text == "" ||
                ticketNumber.text == ""){
            self.present(methods.displayAlert(givenTitle: "Invalid Information", givenMessage: ""), animated: true)
        }
        else if !methods.checkPhoneNumberWithDashes(phoneNumber: phoneField.text ?? "") || !methods.checkEmail(email: emailField.text ?? ""){
            self.present(methods.displayAlert(givenTitle: "Invalid Phone or Email", givenMessage: ""), animated: true)
        }
        else if methods.checkNotDate(dateStr: returnDateField.text ?? ""){
            self.present(methods.displayAlert(givenTitle: "Not a valid date", givenMessage: "Please fill out all required fields"), animated: true)
        }
        else{
            /*If important information is not empty add to core data & check if method added succussfully*/
            saveSigniture()
            
            if(countField.text == ""){
                countField.text = "1"
            }
            
            if(reviewed){
                self.fireBaseMethods.addCheckedOutToFirebase(name: self.nameField.text ?? "", asuriteId: self.asuField.text ?? "", email: self.emailField.text ?? "", phoneNumber: self.phoneField.text ?? "", adaptorType: self.adapterSelector.text ?? "", count: self.countField.text ?? "1", loanedDate: self.dateHolder.text ?? "", expectedReturnDate: self.returnDateField.text ?? "", ticketNumber: self.ticketNumber.text ?? "", reason: self.reasonField.text ?? "", signiture: self.signiture.pngData() ?? UIImage(named: "defaultSigniture.png")!.pngData()!)
                    
                self.savedObject = true
            }else{
                //REVIEW ALERT
                let reviewAlert = UIAlertController(title: "Please Review", message: "Name: \(nameField.text ?? "")\nAsuriteID: \(asuField.text ?? "")\nEmail: \(emailField.text ?? "")\nPhone #: \(phoneField.text ?? "")\nReturn Date: \(returnDateField.text ?? "")\nAdapter Type: \(adapterSelector.text ?? "")", preferredStyle: .alert)
                reviewAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                reviewAlert.addAction(UIAlertAction(title: "Yes, the information is correct", style: .default, handler: {
                    action in
                    self.reviewed = true
                    
                    self.btnCheckout.setTitle("Check Out", for: .normal)
                }))
                
                self.present(reviewAlert, animated: true)
            }
        }
    }
    
    //------------------------------- PREPARE FOR UNWIND SEGUE --------------------------------------//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(savedObject){
            let destinationViewControler = segue.destination as! ListOfCheckedOutItemsViewController
            destinationViewControler.checkedOutTable.reloadData()
        }
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
        clearCanvas()
        self.btnCheckout.setTitle("Review Information", for: .normal)
        reviewed = false
    }
    
    @IBAction func ClearSigniture(_ sender: Any) {
        clearCanvas()
        self.btnCheckout.setTitle("Review Information", for: .normal)
        reviewed = false
    }
    
    //------------------- VIEW TAPPED FUNCTION - CLOSE UI ELEMENTS ---------------------//
    //Function that allows UI elements to close when tapped outside
    @objc func viewTapped(gestureRecognixer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    //------------------------ DATE CHANGED FUNCTION ----------------------------------//
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        returnDateField.text = dateFormatter.string(from: datePicker.date)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        adapterSelector.text =  tempAdapterArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 500.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        switch activeTextField{
        case 1:
            var label:UILabel
            
            if let v = view as? UILabel
            {
                label = v
            }
            else
            {
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
        activeTextField = 1
        adapterPicker.reloadAllComponents()
    }
    
    //------------------------------- SIGNITURE IMAGE SET UP --------------------------------------//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        startingPoint = touch?.location(in: signitureField)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        touchPoint = touch?.location(in: signitureField)
        path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        startingPoint = touchPoint
        
        drawShapeLayer()
    }
    
    func drawShapeLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        signitureField.layer.addSublayer(shapeLayer)
        signitureField.setNeedsDisplay()
    }
    
    func clearCanvas(){
        if(path != nil){
            path.removeAllPoints()
            signitureField.layer.sublayers = nil
            signitureField.setNeedsDisplay()
        }
    }
    
    func saveSigniture(){
        UIGraphicsBeginImageContext(self.signitureField.bounds.size)
        
        // The code below may solve your problem
        signitureField.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        signiture = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
}
