//
//  MethodsForControllers.swift
//  InventoryApp
//
//  Created by Meghan on 11/6/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import Foundation
import UIKit

public class MethodsForController{
    /*clearUI is used to clear all of the text fields in the view controller**/
    func clearUI(viewController:UIViewController){
        for view in viewController.view.subviews{
            if let textField = view as? UITextField{
                textField.text = ""
            }
        }
    }
    
    /*displayAlert displays an alert to the UI with a given title and given message. This alert is only used as a popup to notify the user of something important, usually an error*/
    func displayAlert(givenTitle:String, givenMessage:String) -> UIAlertController{
        let alert = UIAlertController(title: givenTitle, message: givenMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        //viewController(alert, animated: true)
        return alert
    }
    
    //---------------- Validate Phone Number and Email -------------
    func checkPhoneNumberWithDashes(phoneNumber: String) -> Bool{
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phoneNumber)
        return result
    }
    
    func checkEmail(email: String) -> Bool{
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    //---------------- Checks to see if adapter is due for return ------------------------
    func checkOverdue(dateStr: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.date(from: dateStr)!
        
        var todayDate = Date()
        let today = dateFormatter.string(from: todayDate)
        todayDate = dateFormatter.date(from: today)!
        
        return date < todayDate
    }
    
    //--------- Checks to see if string is a date ------------
    func checkNotDate(dateStr: String) -> Bool{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy"
        
        return dateFormatterGet.date(from: dateStr) == nil
    }
    
    //--------- FORMAT EMAIL IN HTML ---------//
    func htmlEmailFormat(eSigniture:String, consumableArray:[Consumable], consumableDictionary:[String:String]) -> String{
        var consumablesInventoryStr = ""
        for consumable in consumableArray{
            
            //check if needs to be reordered
            if(Int(consumableDictionary[consumable.getType()] ?? "0") ?? 0 < Int(consumable.getReOrder()) ?? 0){
                //highlight type red
                if(Int(consumableDictionary[consumable.getType()] ?? "0") ?? 0 > Int(consumable.getCount()) ?? 0){
                    //highlight actual green
                    consumablesInventoryStr += "<font color='red'><b>Type:</b>\(consumable.getType())</font> | <b>Expected Count:</b> \(consumable.getCount()) | <font color='#319716'><b>Actual Count:</b> \(consumableDictionary[consumable.getType()] ?? "")</font> | <b>Reorder Threshold:</b> \(consumable.getReOrder())<br>"
                }else if(Int(consumableDictionary[consumable.getType()] ?? "0") ?? 0 < Int(consumable.getCount()) ?? 0){
                    //hightlight actual red
                    consumablesInventoryStr += "<font color='red'><b>Type:</b>\(consumable.getType())</font> | <b>Expected Count:</b> \(consumable.getCount()) | <font color='red'><b>Actual Count:</b> \(consumableDictionary[consumable.getType()] ?? "")</font> | <b>Reorder Threshold:</b> \(consumable.getReOrder())<br>"
                }else{
                    //do nothing
                    consumablesInventoryStr += "<font color='red'><b>Type:</b>\(consumable.getType())</font> | <b>Expected Count:</b> \(consumable.getCount()) | <b>Actual Count:</b> \(consumableDictionary[consumable.getType()] ?? "") | <b>Reorder Threshold:</b> \(consumable.getReOrder())<br>"
                }
            }else{
                //don't highlight type red
                if(Int(consumableDictionary[consumable.getType()] ?? "0") ?? 0 > Int(consumable.getCount()) ?? 0){
                    //highlight actual green
                    consumablesInventoryStr += "<b>Type:</b>\(consumable.getType()) | <b>Expected Count:</b> \(consumable.getCount()) | <font color='#319716'><b>Actual Count:</b> \(consumableDictionary[consumable.getType()] ?? "")</font> | <b>Reorder Threshold:</b> \(consumable.getReOrder())<br>"
                }else if(Int(consumableDictionary[consumable.getType()] ?? "0") ?? 0 < Int(consumable.getCount()) ?? 0){
                    //hightlight actual red
                    consumablesInventoryStr += "<b>Type:</b>\(consumable.getType()) | <b>Expected Count:</b> \(consumable.getCount()) | <font color='red'><b>Actual Count:</b> \(consumableDictionary[consumable.getType()] ?? "")</font> | <b>Reorder Threshold:</b> \(consumable.getReOrder())<br>"
                }else{
                    //do nothing
                    consumablesInventoryStr += "<b>Type:</b>\(consumable.getType()) | <b>Expected Count:</b> \(consumable.getCount()) | <b>Actual Count:</b> \(consumableDictionary[consumable.getType()] ?? "") | <b>Reorder Threshold:</b> \(consumable.getReOrder())<br>"
                }
            }
        }
        
        return """
        <h2>Consumable Inventory Update</h2>
        <h4>Completed by \(eSigniture)</h4>
        <p>\(consumablesInventoryStr)</p>
        <h4>Notes: <br></h4>
        """
    }
}
