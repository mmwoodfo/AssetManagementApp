//
//  CheckedOut.swift
//  InventoryApp
//
//  Created by Meghan on 12/13/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import Foundation
import UIKit

public class CheckedOut{
    private var name: String
    private var asuriteId: String
    private var email: String
    private var phoneNumber: String
    private var reason: String
    private var loanedDate: String
    private var expectedReturnDate: String
    private var adaptorType: String
    private var count:String
    private var ticketNumber: String
    private var signiture: String
    
    init (aDict: [String: AnyObject]){
        self.name = aDict["Name"] as! String
        self.asuriteId = aDict["AsuriteID"] as! String
        self.email = aDict["Email"] as! String
        self.phoneNumber = aDict["PhoneNumber"] as! String
        self.reason = aDict["Reason"] as! String
        self.loanedDate = aDict["LoanedDate"] as! String
        self.expectedReturnDate = aDict["ExpectedReturnDate"] as! String
        self.adaptorType = aDict["AdaptorType"] as! String
        self.count = aDict["Count"] as! String
        self.ticketNumber = aDict["TicketNumber"] as! String
        self.signiture = aDict["SignitureUrl"] as? String ?? ""
    }
    
    //getter methods
    public func getName() -> String{
        return self.name
    }
    
    public func getAsuriteId() -> String{
        return self.asuriteId
    }
    
    public func getEmail() -> String{
        return self.email
    }
    
    public func getPhone() -> String{
        return self.phoneNumber
    }
    
    public func getReason() -> String{
        return self.reason
    }
    
    public func getLoanedDate() -> String{
        return self.loanedDate
    }
    
    public func getExpectedReturnDate() -> String{
        return self.expectedReturnDate
    }
    
    public func getAdaptorType() -> String{
        return self.adaptorType
    }
    
    public func getCount() -> String{
        return self.count
    }
    
    public func getTicketNumber() -> String{
        return self.ticketNumber
    }
    
    public func getSigniture() -> String{
        return self.signiture
    }
}
