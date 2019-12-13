//
//  MethodsForControllers.swift
//  InventoryApp
//
//  Created by Meghan on 11/6/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
    
    //========================================= CORE DATA ==========================================================//
    //Core data variables
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //moc = managed object context
    var checkedout = [CheckoutEntity]()
    var assigned = [AssignedEntity]()
    var consumable = [ConsumableEntity]()
    
    //----------------------- ADD ASSIGNED ENTITY TO CORE DATA ---------------------------//
    func addAssignedEntityToCoreData(name:String, asurite:String, email:String, phone:String, reason:String, todayDate:String, adaptorName:String, ticketNumber:String) -> Bool{
        let ent = NSEntityDescription.entity(forEntityName: "AssignedEntity", in: moc)
        let newAssignedItem = AssignedEntity(entity: ent!, insertInto: moc)
        newAssignedItem.name = name
        newAssignedItem.asuriteId = asurite
        newAssignedItem.email = email
        newAssignedItem.phoneNumber = phone
        newAssignedItem.reason = reason
        newAssignedItem.loanedDate = todayDate
        newAssignedItem.adaptorName = adaptorName
        newAssignedItem.ticketNumber = ticketNumber
        
        do{
            try moc.save()
            return true
        }catch _{
            return false
        }
    }
    
    //----------------------- REMOVE ASSIGNED ENTITY FROM CORE DATA ---------------------------//
    func deleteAssignedEntity(entity:AssignedEntity){
        moc.delete(entity)
        do{
            try moc.save()
            print("Saved.")
        }catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
    //------------------ RETURN LIST OF ASSIGNED ENTITIES IN CORE DATA ----------------------//
    func fetchAssignedEntity() -> [AssignedEntity]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AssignedEntity")
        
        assigned = ((try? moc.fetch(fetchRequest)) as? [AssignedEntity])!
        
        return assigned
    }
    
    //----------------------- RETURN LIST OF CONSUMABLE TYPES IN CORE DATA -----------------------//
    func fetchConsumableTypes() -> [String] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConsumableEntity")
        
        consumable = ((try? moc.fetch(fetchRequest)) as? [ConsumableEntity])!
        
        var types = [String]()
        
        for item in consumable{
            types.append(item.type ?? "")
        }
        
        return types
    }
}
