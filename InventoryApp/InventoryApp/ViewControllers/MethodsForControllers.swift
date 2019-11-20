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
    
    //---------------- Checks to see if adapter is due for return ------------------------
    func checkOverdue(dateStr: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.date(from: dateStr)!
        
        let todayDate = Date()
        
        return date < todayDate
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
    func addConsumableEntityToCoreData(type:String, count:Int32) -> Bool{
        let ent = NSEntityDescription.entity(forEntityName: "ConsumableEntity", in: moc)
        let newConsumableItem = ConsumableEntity(entity: ent!, insertInto: moc)
        newConsumableItem.type = type
        newConsumableItem.count = count
        
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
}
