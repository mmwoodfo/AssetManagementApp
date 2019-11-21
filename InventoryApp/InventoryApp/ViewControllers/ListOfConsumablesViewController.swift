//
//  ListOfConsumablesViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class ListOfConsumablesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

     private var methods:MethodsForController = MethodsForController()
        private var consumableArray = [ConsumableEntity]()
        
        @IBOutlet weak var consumableTable: UITableView!
        
        override func viewDidLoad() {
            super.viewDidLoad()

            populateConsumableArray()
            
            self.consumableTable.dataSource = self
            self.consumableTable.delegate = self
        }
        
        //---------------------- POPULATE CONSUMABLE ARRAY --------------------------------//
        private func populateConsumableArray(){
            consumableArray = methods.fetchConsumableEntity()
            consumableArray.sort{ ($0.type ?? "") < ($1.type ?? "") }
        }
    
    //===========================Functions for Table view Cells and the Table=======================
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return consumableArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "consumableCell", for: indexPath) as! ConsumablesCell
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.backgroundColor = UIColor.white
            cell.adapterType.text = consumableArray[indexPath.row].type
            cell.count.text = String(consumableArray[indexPath.row].count)
            
            if consumableArray[indexPath.row].count <= 0{
                cell.count.textColor = UIColor.red
            }
            
            cell.sku.text = consumableArray[indexPath.row].sku
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
        }
    
        func reloadTableView(){
            populateConsumableArray()
            consumableTable.reloadData()
        }
        
        //=============== Delete From Table  ======================
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
        {
            return true
        }
        
        private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
            return UITableViewCell.EditingStyle.delete
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
            methods.deleteConsumableEntity(entity: consumableArray[indexPath.row])
            reloadTableView()
        }
    
    //=============== EDIT CELLS IN TABLE  ======================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editConsumableCount = UIAlertController(title: "Change Count", message: nil, preferredStyle: .alert)
        editConsumableCount.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editConsumableCount.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Consumable Count"
        })
        
        editConsumableCount.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            action in
            if let count = editConsumableCount.textFields?[0].text{
                if count != "" {
                    if self.methods.changeConsumableCount(consumableName: self.consumableArray[indexPath.item].type ?? "", newCount: Int32(count) ?? 0) {
                        print("Count Changed")
                    }else{
                        print("Count not Changed")
                    }
                    self.reloadTableView()
                }
            }
        }))
        
        self.present(editConsumableCount, animated: true)
        
    }
      
    @IBAction func addConsumable(_ sender: Any) {
        let consumableAlert = UIAlertController(title: "Add Consumable", message: nil, preferredStyle: .alert)
        consumableAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        consumableAlert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Consumable Type"
        })
        
        consumableAlert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Consumable Count"
        })
        
        consumableAlert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Item SKU"
        })
        
        consumableAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            action in
            if let name = consumableAlert.textFields?[0].text{
                if let count = consumableAlert.textFields?[1].text{
                    if let sku = consumableAlert.textFields?[2].text{
                        if name != "" && count != "" && sku != ""{
                            let consumableTemp = self.methods.fetchConsumableTypes()
                            //check to make sure item is not a duplicate
                            if consumableTemp.contains(name){
                                self.present(self.methods.displayAlert(givenTitle: "Error adding - That Consumable Already Exists", givenMessage: "The consumable \(name) is already in this list"), animated: true)
                            //add to core data
                            }else if !self.methods.addConsumableEntityToCoreData(type: name, count: Int32(count) ?? 0, sku: sku){
                                self.present(self.methods.displayAlert(givenTitle:"Error adding to core data", givenMessage:"Check your values and try again"), animated: true)
                            }else{
                                self.reloadTableView()
                            }
                        }else{
                            self.present(self.methods.displayAlert(givenTitle: "Error adding - Missing Information", givenMessage: "Please try again and fill out all the required information"), animated: true)
                        }
                    }
                }
            }
        }))
        
        self.present(consumableAlert, animated: true)
    }
}
