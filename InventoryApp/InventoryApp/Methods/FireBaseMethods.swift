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
    
    //------------------- ADD TO FIREBASE ------------------//
    
    public func addConsumableToFirebase(type:String, count:String, sku:String, ref:DatabaseReference){
        let consumable = [
            "Type":  type,
            "Count": count,
            "Sku":   sku
        ]
        ref.child("Consumables").child(type).setValue(consumable)
    }
    
    public func addAssignedToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, loanedDate:String, ticketNumber:String, reason:String, ref:DatabaseReference){
        let assigned = [
            "Name":  name,
            "AsuriteID": asuriteId,
            "Email":   email,
            "Phone#": phoneNumber,
            "Reason": reason,
            "LoanedDate": loanedDate,
            "AdaptorType": adaptorType,
            "Ticket#": ticketNumber,
            ]

        ref.child("AssignedConsumables").child(name).setValue(assigned)
    }
    
    public func addCheckedOutToFirebase(name:String, asuriteId:String, email:String, phoneNumber:String, adaptorType:String, loanedDate:String, expectedReturnDate:String, ticketNumber:String, reason:String, signiture:Data, ref:DatabaseReference){
        let checkedOut = [
            "Name":  name,
            "AsuriteID": asuriteId,
            "Email":   email,
            "Phone#": phoneNumber,
            "Reason": reason,
            "LoanedDate": loanedDate,
            "ExpectedReturnDate": expectedReturnDate,
            "AdaptorType": adaptorType,
            "Ticket#": ticketNumber,
            "Signiture": signiture
            ] as [String : Any]

        ref.child("CheckedOutConsumables").child(name).setValue(checkedOut)
    }
}
