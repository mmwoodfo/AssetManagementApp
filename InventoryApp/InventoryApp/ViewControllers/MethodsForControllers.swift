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
        
        let todayDate = Date()
        
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
    
    //----------------------- ADD CHECKED OUT ENTITY TO CORE DATA ---------------------------//
    func addCheckoutEntityToCoreData(name:String, asurite:String, email:String, phone:String, reason:String, todayDate:String, expectedReturnDate:String, adaptorName:String) -> Bool{
        let ent = NSEntityDescription.entity(forEntityName: "CheckoutEntity", in: moc)
        let newCheckedOutItem = CheckoutEntity(entity: ent!, insertInto: moc)
        newCheckedOutItem.name = name
        newCheckedOutItem.asuriteId = asurite
        newCheckedOutItem.email = email
        newCheckedOutItem.phoneNumber = phone
        newCheckedOutItem.reason = reason
        newCheckedOutItem.loanedDate = todayDate
        newCheckedOutItem.expectedReturnDate = expectedReturnDate
        newCheckedOutItem.adaptorName = adaptorName
        
        do{
            try moc.save()
            return true
        }catch _{
            return false
        }
    }
    
    //----------------------- ADD ASSIGNED ENTITY TO CORE DATA ---------------------------//
    func addAssignedEntityToCoreData(name:String, asurite:String, email:String, phone:String, reason:String, todayDate:String, adaptorName:String) -> Bool{
        let ent = NSEntityDescription.entity(forEntityName: "AssignedEntity", in: moc)
        let newAssignedItem = AssignedEntity(entity: ent!, insertInto: moc)
        newAssignedItem.name = name
        newAssignedItem.asuriteId = asurite
        newAssignedItem.email = email
        newAssignedItem.phoneNumber = phone
        newAssignedItem.reason = reason
        newAssignedItem.loanedDate = todayDate
        newAssignedItem.adaptorName = adaptorName
        
        do{
            try moc.save()
            return true
        }catch _{
            return false
        }
    }
    
    //----------------------- ADD CONSUMABLE ENTITY TO CORE DATA ---------------------------//
    func addConsumableEntityToCoreData(type:String, count:Int32, sku:String) -> Bool{
        let ent = NSEntityDescription.entity(forEntityName: "ConsumableEntity", in: moc)
        let newConsumableItem = ConsumableEntity(entity: ent!, insertInto: moc)
        newConsumableItem.type = type
        newConsumableItem.count = count
        newConsumableItem.sku = sku
        
        do{
            try moc.save()
            return true
        }catch _{
            return false
        }
    }
    
    //----------------------- REMOVE CHECKEDOUT ENTITY FROM CORE DATA ---------------------------//
    func deleteCheckedoutEntity(entity:CheckoutEntity){
        moc.delete(entity)
        do{
            try moc.save()
            print("Saved.")
        }catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
    //------------------ RETURN LIST OF CHECKED OUT ENTITIES IN CORE DATA ----------------------//
    func fetchCheckedoutEntity() -> [CheckoutEntity]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CheckoutEntity")

        checkedout = ((try? moc.fetch(fetchRequest)) as? [CheckoutEntity])!
        
        return checkedout
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
    
    //----------------------- REMOVE CONSUMABLE ENTITY FROM CORE DATA ---------------------------//
    func deleteConsumableEntity(entity:ConsumableEntity){
        moc.delete(entity)
        do{
            try moc.save()
            print("Saved.")
        }catch let error as NSError {
            print("Could not save. \(error)")
        }
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
    
    //------------------ RETURN LIST OF CONSUMABLE ENTITIES IN CORE DATA ----------------------//
    func fetchConsumableEntity() -> [ConsumableEntity]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ConsumableEntity")

        consumable = ((try? moc.fetch(fetchRequest)) as? [ConsumableEntity])!
        
        return consumable
    }
    
    //--------------- CHANGE COUNT OF CONSUMABLE IN CORE DATA -----------------//
    func changeConsumableCount(consumableName:String, newCount:Int32) -> Bool{
        let consumableList = fetchConsumableEntity()
        
        var index = -1
        
        for entity in consumableList{
            index = index + 1
            if entity.type == consumableName{
                break
            }
        }
        
        let savedType = consumableList[index].type
        let savedSku = consumableList[index].sku
        deleteConsumableEntity(entity: consumableList[index])
        return addConsumableEntityToCoreData(type: savedType ?? "", count: newCount, sku: savedSku ?? "")
    }
    
    //--------------- INCREASE COUNT OF CONSUMABLE IN CORE DATA -----------------//
    func IncreaseConsumableCount(consumableName:String) -> Bool{
        let consumableList = fetchConsumableEntity()
        
        var index = -1
        var found = false
        
        for entity in consumableList{
            index += 1
            if entity.type == consumableName{
                found = true
                break
            }
        }
        
        if found{
            let savedType = consumableList[index].type
            let savedSku = consumableList[index].sku
            let oldCount = consumableList[index].count
            let newCount = oldCount + 1
            deleteConsumableEntity(entity: consumableList[index])
            return addConsumableEntityToCoreData(type: savedType ?? "", count: newCount, sku: savedSku ?? "")
        }else{
            return false
        }
    }
    
    //--------------- DECREASE COUNT OF CONSUMABLE IN CORE DATA -----------------//
    func decreaseConsumableCount(consumableName:String) -> Bool{
        let consumableList = fetchConsumableEntity()
        
        var index = -1
        var found = false
        
        for entity in consumableList{
            index += 1
            //print("EntityName: \(entity.type) and ConsumableName: \(consumableName)")
            if entity.type == consumableName{
                found = true
                break
            }
        }
        
        if found{
            let savedType = consumableList[index].type
            let savedSku = consumableList[index].sku
            let oldCount = consumableList[index].count
            let newCount = oldCount - 1
            deleteConsumableEntity(entity: consumableList[index])
            return addConsumableEntityToCoreData(type: savedType ?? "", count: newCount, sku: savedSku ?? "")
        }else{
            return false
        }
    }
}
