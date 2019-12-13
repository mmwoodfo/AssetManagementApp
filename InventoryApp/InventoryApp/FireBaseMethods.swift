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
    
    public let consumablesDbId = "Consumables"
    public let assignedDbId = "AssignedConsumables"
    public let checkedOutDbId = "CheckedOutConsumables"
    
    public func getConsumablesDbId() -> String{
        return consumablesDbId
    }
    
    public func getAssignedDbId() -> String{
        return assignedDbId
    }
    
    public func getCheckedOutDbId() -> String{
        return checkedOutDbId
    }
    
    //------------------- ADD TO FIREBASE ------------------//
    
    public func addConsumableToFirebase(type:String, count:String, sku:String, ref:DatabaseReference){
        let consumable = [
            "Type":  type,
            "Count": count,
            "Sku":   sku
        ]
        ref.child(consumablesDbId).child(type).setValue(consumable)
    }
    
    public func addAssignedToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, loanedDate:String, ticketNumber:String, reason:String, ref:DatabaseReference){
        ref.child(assignedDbId).child(name).child("Name").setValue(name)
        ref.child(assignedDbId).child(name).child("Asurite").setValue(asuriteId)
        ref.child(assignedDbId).child(name).child("Email").setValue(email)
        ref.child(assignedDbId).child(name).child("PhoneNumber").setValue(phoneNumber)
        ref.child(assignedDbId).child(name).child("AdaptorType").setValue(adaptorType)
        ref.child(assignedDbId).child(name).child("LoanedDate").setValue(loanedDate)
        ref.child(assignedDbId).child(name).child("Ticket#").setValue(ticketNumber)
        ref.child(assignedDbId).child(name).child("Reason").setValue(reason)
    }
    
    public func addCheckedOutToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, loanedDate:String, expectedReturnDate:String, ticketNumber:String, reason:String, signiture:Data, ref:DatabaseReference){
        ref.child(checkedOutDbId).child(name).child("Name").setValue(name)
        ref.child(checkedOutDbId).child(name).child("Asurite").setValue(asuriteId)
        ref.child(checkedOutDbId).child(name).child("Email").setValue(email)
        ref.child(checkedOutDbId).child(name).child("PhoneNumber").setValue(phoneNumber)
        ref.child(checkedOutDbId).child(name).child("AdaptorType").setValue(adaptorType)
        ref.child(checkedOutDbId).child(name).child("LoanedDate").setValue(loanedDate)
        ref.child(checkedOutDbId).child(name).child("ExpectedReturnDate").setValue(expectedReturnDate)
        ref.child(checkedOutDbId).child(name).child("Ticket#").setValue(ticketNumber)
        ref.child(checkedOutDbId).child(name).child("Reason").setValue(reason)
        ref.child(checkedOutDbId).child(name).child("Signiture").setValue(signiture)
    }
}
