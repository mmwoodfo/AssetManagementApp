//
//  Consumable.swift
//  InventoryApp
//
//  Created by Meghan on 12/13/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import Foundation

public class Consumable{
    private var type:String
    private var count:String
    private var sku:String
    private var reOrder:String
    
    init (aDict: [String: AnyObject]){
        self.type = aDict["Type"] as! String
        self.count = aDict["Count"] as! String
        self.sku = aDict["Sku"] as! String
        self.reOrder = aDict["ReOrder"] as! String
    }
    
    //setter methods
    public func setType(type:String){
        self.type = type
    }
    
    public func setCount(count:String){
        self.count = count
    }
    
    public func setSku(sku:String){
        self.sku = sku
    }
    
    public func setReOrder(reOrder:String){
        self.reOrder = reOrder
    }
    
    //getter methods
    public func getType() -> String{
        return type
    }
    
    public func getCount() -> String{
        return count
    }
    
    public func getSku() -> String{
        return sku
    }
    
    public func getReOrder() -> String{
        return reOrder
    }
}
