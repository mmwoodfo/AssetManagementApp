//
//  CheckedoutItem.swift
//  InventoryApp
//
//  Created by Meghan on 11/1/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import Foundation

public class CheckedoutItem{
    private var name:String
    private var asuriteId:String
    private var email:String
    private var phoneNumber:String
    private var reason:String
    private var loanedDate:String
    private var expectedReturnDate:String
    private var adaptorName:String
    
    public init(name:String, asuriteId:String, email:String, phoneNumber:String, reason:String, expectedReturnDate:String, adaptorName:String){
        self.name = name
        self.asuriteId = asuriteId
        self.email = email
        self.phoneNumber = phoneNumber
        self.reason = reason
        self.expectedReturnDate = expectedReturnDate
        self.adaptorName = adaptorName
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        self.loanedDate = "\(day)/\(month)/\(year)"
    }
    
    public func toString() -> String{
        return "Name: \(name)/nAsurite ID: \(asuriteId)/nE-Mail: \(email)/nPhone #: \(phoneNumber)/nReason: \(reason)/nLoaned Date: \(loanedDate)/nExpected return date: \(expectedReturnDate)/nAdaptor Borrowed\(adaptorName)"
    }
}
