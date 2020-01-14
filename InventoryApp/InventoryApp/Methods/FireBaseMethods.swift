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
    
    private let ref = Database.database().reference()
    
    //------------------- ADD TO FIREBASE ------------------//
    
    public func addConsumableToFirebase(type:String, count:String, sku:String){
        let consumable = [
            "Type":  type,
            "Count": count,
            "Sku":   sku
        ]
        ref.child("Consumables").child(type).setValue(consumable)
    }
    
    public func addAssignedToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, count:String, loanedDate:String, ticketNumber:String, reason:String){
        let assigned = [
            "Name":  name,
            "AsuriteID": asuriteId,
            "Email":   email,
            "PhoneNumber": phoneNumber,
            "Reason": reason,
            "LoanedDate": loanedDate,
            "AdaptorType": adaptorType,
            "Count": count,
            "TicketNumber": ticketNumber
        ]
        
        ref.child("AssignedConsumables").child(hashAssigned(asuriteId: asuriteId, adapterType: adaptorType, loanedDate: loanedDate)).setValue(assigned)
        decreaseAdapterCount(adapterType: adaptorType, amount: Int(count) ?? 1)
    }
    
    public func addCheckedOutToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, count:String, loanedDate:String, expectedReturnDate:String, ticketNumber:String, reason:String, signiture:Data){
        
        decreaseAdapterCount(adapterType: adaptorType, amount: Int(count) ?? 1)
        let child:String = hashCheckedOut(asuriteId: asuriteId, expectedReturn: expectedReturnDate, adapterType: adaptorType, loanedDate: loanedDate)
        let storageRef = Storage.storage().reference().child("\(child).png")
        
        //upload image
        storageRef.putData(signiture, metadata: nil) { (metadata, error) in
            if error != nil{
                print(error!)
                return
            }
            
            print(metadata!)
            
            // Fetch the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    // Handle any errors
                    print(error)
                    return
                } else {
                    let urlStr:String = (url?.absoluteString) ?? ""
                    print(urlStr)
                    
                    self.addCheckedOutToFirebase(name: name, asuriteId: asuriteId, email: email, phoneNumber: phoneNumber, adaptorType: adaptorType, count: count, loanedDate: loanedDate, expectedReturnDate: expectedReturnDate, ticketNumber: ticketNumber, reason: reason, signitureUrl: urlStr)
                }
            }
        }
    }
    
    public func addCheckedOutToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, count:String, loanedDate:String, expectedReturnDate:String, ticketNumber:String, reason:String, signitureUrl:String){
        
        let checkedOut = [
            "Name":  name,
            "AsuriteID": asuriteId,
            "Email":   email,
            "PhoneNumber": phoneNumber,
            "Reason": reason,
            "LoanedDate": loanedDate,
            "ExpectedReturnDate": expectedReturnDate,
            "AdaptorType": adaptorType,
            "Count": count,
            "TicketNumber": ticketNumber,
            "SignitureUrl": signitureUrl
        ]
        
        ref.child("CheckedOutConsumables").child(self.hashCheckedOut(asuriteId: asuriteId, expectedReturn: expectedReturnDate, adapterType: adaptorType, loanedDate: loanedDate)).setValue(checkedOut)
    }
    
    //------------------- MAKE HASH NAME -----------------//
    func hashCheckedOut(asuriteId:String, expectedReturn:String, adapterType:String, loanedDate:String) -> String{
        return "\(asuriteId) \(expectedReturn) \(adapterType) \(loanedDate)"
    }
    
    func hashAssigned(asuriteId:String, adapterType:String, loanedDate:String) -> String{
        return "\(asuriteId) \(adapterType) \(loanedDate)"
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
    
    //----------------- GET ADAPTER TYPES -------------------//
    public func getAdapterTypes(completion: @escaping (String) -> Void){
        ref.child("Consumables").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                completion(snap.key)
            }
        })
    }
    
    //---------------- REMOVE FROM FIREBASE ----------------//
    public func removeConsumableFromFirebase(type:String){
        let refToDelete = ref.child("Consumables").child(type)
        refToDelete.removeValue()
    }
    
    public func removeCheckedOutFromFirebase(asuriteId:String, type:String, expectedReturn:String, loanedDate:String, count:String, signitureURL:String){
        increaseAdapterCount(adapterType: type, amount: Int(count) ?? 1)
        
        let hashCode = hashCheckedOut(asuriteId: asuriteId, expectedReturn: expectedReturn, adapterType: type, loanedDate: loanedDate)
        
        //delete firebase PNG image
        let storage = Storage.storage()
        let signitureReference = storage.reference(forURL: signitureURL)
        
        signitureReference.delete { error in
            if let error = error {
                print(error)
            } else {
                print("signiture deleted")
            }
        }
        
        //delete firebase JSON object
        let refToDelete = ref.child("CheckedOutConsumables").child(hashCode)
        refToDelete.removeValue()
    }
    
    public func removeAssignedFromFirebase(asuriteId:String, type:String, loanedDate:String, count:String){
        increaseAdapterCount(adapterType: type, amount: Int(count) ?? 1)
        
        let refToDelete = ref.child("AssignedConsumables").child(hashAssigned(asuriteId: asuriteId, adapterType: type, loanedDate: loanedDate))
        refToDelete.removeValue()
    }
    
    //------------ DECREASE / INCREASE COUNT OF ADAPTERS -------------//
    public func increaseAdapterCount(adapterType:String, amount:Int){
        var consumableArray = [Consumable]()
        var count:Int = 0
        
        populateConsumableTableArray { [weak self] consumable in
            consumableArray.append(consumable)
            DispatchQueue.main.async {
                for consumable in consumableArray{
                    if(consumable.getType() == adapterType){
                        count = Int(consumable.getCount()) ?? 0
                        self?.ref.child("Consumables").child(adapterType).child("Count").setValue(String(count+amount))
                    }
                }
            }
        }
    }
    
    public func decreaseAdapterCount(adapterType:String, amount:Int){
        var consumableArray = [Consumable]()
        var count:Int = 0
        
        populateConsumableTableArray { [weak self] consumable in
            consumableArray.append(consumable)
            DispatchQueue.main.async {
                for consumable in consumableArray{
                    if(consumable.getType() == adapterType){
                        count = Int(consumable.getCount()) ?? 0
                        self?.ref.child("Consumables").child(adapterType).child("Count").setValue(String(count-amount))
                    }
                }
            }
        }
    }
    
    public func editConsumable(type:String, Sku:String, newCount:String, newType:String){
        removeConsumableFromFirebase(type: type)
        addConsumableToFirebase(type: newType, count: newCount, sku: Sku)
    }
    
    public func removeObservers(){
        self.ref.child("Consumables").removeAllObservers()
        self.ref.child("CheckedOutConsumables").removeAllObservers()
        self.ref.child("AssignedConsumables").removeAllObservers()
    }
    
    //------------- UPDATE TICKET ID ---------//
    public func updateCheckedOutTicket(asuriteId:String, expectedReturn:String, adapterType: String, loanedDate: String, newTicketID:String){
        let hashCode = hashCheckedOut(asuriteId: asuriteId, expectedReturn: expectedReturn, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("CheckedOutConsumables").child(hashCode).child("TicketNumber").setValue(newTicketID)
    }
    
    public func updateAssignedTicket(asuriteId:String, adapterType: String, loanedDate: String, newTicketID:String){
        let hashCode = hashAssigned(asuriteId: asuriteId, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("AssignedConsumables").child(hashCode).child("TicketNumber").setValue(newTicketID)
    }
    
    //--------- UPDATE NAME ------------//
    public func updateCheckedOutName(asuriteId:String, expectedReturn:String, adapterType: String, loanedDate: String, newName:String){
        let hashCode = hashCheckedOut(asuriteId: asuriteId, expectedReturn: expectedReturn, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("CheckedOutConsumables").child(hashCode).child("Name").setValue(newName)
    }
    
    public func updateAssignedName(asuriteId:String, adapterType: String, loanedDate: String, newName:String){
        let hashCode = hashAssigned(asuriteId: asuriteId, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("CheckedOutConsumables").child(hashCode).child("Name").setValue(newName)
    }
    
    //------- UPDATE EMAIL -----------//
    public func updateCheckedOutEmail(asuriteId:String, expectedReturn:String, adapterType: String, loanedDate: String, newEmail:String){
        let hashCode = hashCheckedOut(asuriteId: asuriteId, expectedReturn: expectedReturn, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("CheckedOutConsumables").child(hashCode).child("Email").setValue(newEmail)
    }
    
    public func updateAssignedEmail(asuriteId:String, adapterType: String, loanedDate: String, newEmail:String){
        let hashCode = hashAssigned(asuriteId: asuriteId, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("CheckedOutConsumables").child(hashCode).child("Email").setValue(newEmail)
    }
    
    //------- UPDATE PHONE ---------//
    public func updateCheckedOutPhoneNumber(asuriteId:String, expectedReturn:String, adapterType: String, loanedDate: String, newPhoneNumber:String){
        let hashCode = hashCheckedOut(asuriteId: asuriteId, expectedReturn: expectedReturn, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("CheckedOutConsumables").child(hashCode).child("PhoneNumber").setValue(newPhoneNumber)
    }
    
    public func updateAssignedPhoneNumber(asuriteId:String, adapterType: String, loanedDate: String, newPhoneNumber:String){
        let hashCode = hashAssigned(asuriteId: asuriteId, adapterType: adapterType, loanedDate: loanedDate)
        ref.child("CheckedOutConsumables").child(hashCode).child("PhoneNumber").setValue(newPhoneNumber)
    }
}
