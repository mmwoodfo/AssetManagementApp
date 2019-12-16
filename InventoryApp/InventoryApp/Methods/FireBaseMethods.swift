//
//  FireBaseMethods.swift
//  InventoryApp
//
//  Created by Meghan on 12/12/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import Foundation
import Firebase

public class FireBaseMethods{
    
    private var ref:DatabaseReference = Database.database().reference()
    
    //------------------- ADD TO FIREBASE ------------------//
    
    public func addConsumableToFirebase(type:String, count:String, sku:String){
        let consumable = [
            "Type":  type,
            "Count": count,
            "Sku":   sku
        ]
        ref.child("Consumables").child(type).setValue(consumable)
    }
    
    public func addAssignedToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, loanedDate:String, ticketNumber:String, reason:String){
        let assigned = [
            "Name":  name,
            "AsuriteID": asuriteId,
            "Email":   email,
            "PhoneNumber": phoneNumber,
            "Reason": reason,
            "LoanedDate": loanedDate,
            "AdaptorType": adaptorType,
            "TicketNumber": ticketNumber,
        ]
        
        ref.child("AssignedConsumables").child(name).setValue(assigned)
        decreaseAdapterCount(adapterType: adaptorType)
    }
    
    public func addCheckedOutToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, loanedDate:String, expectedReturnDate:String, ticketNumber:String, reason:String, signiture:Data){
        let checkedOut = [
            "Name":  name,
            "AsuriteID": asuriteId,
            "Email":   email,
            "PhoneNumber": phoneNumber,
            "Reason": reason,
            "LoanedDate": loanedDate,
            "ExpectedReturnDate": expectedReturnDate,
            "AdaptorType": adaptorType,
            "TicketNumber": ticketNumber,
            "Signiture": signiture
            ] as [String : Any]
        
        ref.child("CheckedOutConsumables").child(name).setValue(checkedOut)
        decreaseAdapterCount(adapterType: adaptorType)
    }
    
    //-------------- POPULATE TABLE ARRAY -----------------//
    public func populateConsumableTableArray(completion: @escaping (Consumable) -> Void) {

        //let the object populate itself.
        ref.child("Consumables").observe(.childAdded, with: { snapshot in
            let dataChange = snapshot.value as? [String:AnyObject]
            let aRequest = Consumable(aDict: dataChange!)
            completion(aRequest)
        })
    }
    
    public func populateCheckedOutTableArray(completion: @escaping (CheckedOut) -> Void) {

        //let the object populate itself.
        ref.child("CheckedOutConsumables").observe(.childAdded, with: { snapshot in
            let dataChange = snapshot.value as? [String:AnyObject]
            let aRequest = CheckedOut(aDict: dataChange!)
            completion(aRequest)
        })
    }
    
    public func populateAssignedTableArray(completion: @escaping (Assigned) -> Void) {

        //let the object populate itself.
        ref.child("AssignedConsumables").observe(.childAdded, with: { snapshot in
            let dataChange = snapshot.value as? [String:AnyObject]
            let aRequest = Assigned(aDict: dataChange!)
            completion(aRequest)
        })
    }
    
    //---------------- REMOVE FROM FIREBASE ----------------//
    public func removeConsumableFromFirebase(type:String){
        let refToDelete = ref.child("Consumables").child(type)
        refToDelete.removeValue()
    }
    
    public func removeCheckedOutFromFirebase(name:String, type:String){
        increaseAdapterCount(adapterType: type)
        
        let refToDelete = ref.child("CheckedOutConsumables").child(name)
        refToDelete.removeValue()
    }
    
    public func removeAssignedFromFirebase(name:String, type:String){
        increaseAdapterCount(adapterType: type)
        
        let refToDelete = ref.child("AssignedConsumables").child(name)
        refToDelete.removeValue()
    }
    
    //----------------- GET ADAPTER TYPES -------------------//
    public func getAdapterTypes() -> [String]{
        var adapterArray = [String]()
        adapterArray.append("")
        
        ref.child("Consumables").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                print("key = \(key)  value = \(value!)")
                adapterArray.append(key)
            }
        })
        return adapterArray
    }
    
    //------------ DECREASE / INCREASE COUNT OF ADAPTERS -------------//
    public func increaseAdapterCount(adapterType:String){
        let count = ref.child("Consumables").child(adapterType).value(forKey: "Count") as! Int
        ref.child("Consumables").child(adapterType).setValue(count+1)
    }
    
    public func decreaseAdapterCount(adapterType:String){
        let count = ref.child("Consumables").child(adapterType).value(forKey: "Count") as! Int
        ref.child("Consumables").child(adapterType).setValue(count-1)
    }
    
    public func changeAdapterCount(type:String, count:String){
        ref.child("Consumables").child(type).child("Count").setValue(count)
    }
}
