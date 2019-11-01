//
//  Consumables.swift
//  InventoryApp
//
//  Created by Meghan on 11/1/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import Foundation

public class Consumable{
    private var type:String
    private var count:Int
    
    public init(type:String, count:Int){
        self.type = type
        self.count = count
    }
    
    public func decreaseCount(){
        count = count - 1
    }
    
    public func increaseCount(){
        count = count + 1
    }
    
    public func toString() -> String{
        return "Adaptor name: \(type), Count: \(count)"
    }
}
