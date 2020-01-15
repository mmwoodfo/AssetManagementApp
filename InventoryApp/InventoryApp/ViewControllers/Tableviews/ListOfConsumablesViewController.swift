//
//  ListOfConsumablesViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class ListOfConsumablesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var methods:MethodsForController = MethodsForController()
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    private var consumableArray = [Consumable]()
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var consumableTable: UITableView!
    
    //-------------------- VIEW DID LOAD -----------------------//
    override func viewDidLoad() {
        super.viewDidLoad()
        self.consumableTable.dataSource = self
        self.consumableTable.delegate = self
        
        consumableTable.contentInset.bottom = 100
        
        fireBaseMethods.populateConsumableTableArray { consumable in
            self.consumableArray.append(consumable)
            DispatchQueue.main.async {
                self.consumableTable.reloadData()
            }
        }
    }
    
    //----------------------- RELOAD TABLE --------------------//
    func reloadTable(){
        consumableArray.sort{ ($0.getType()) < ($1.getType()) }
        self.consumableTable.reloadData()
    }
    
    //--------------------- ADD CELLS TO TABLE  ----------------------//
    @IBAction func addConsumable(_ sender: Any) {
        let consumableAlert = UIAlertController(title: "Add Consumable", message: nil, preferredStyle: .alert)
        consumableAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        consumableAlert.addTextField(configurationHandler: {
            textField in
            textField.autocapitalizationType = .words
            textField.placeholder = "Consumable Type"
        })
        
        consumableAlert.addTextField(configurationHandler: {
            textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "Consumable Count"
        })
        
        consumableAlert.addTextField(configurationHandler: {
            textField in
            textField.autocapitalizationType = .allCharacters
            textField.placeholder = "Item SKU"
        })
        
        consumableAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            action in
            if let type = consumableAlert.textFields?[0].text{
                if let count = consumableAlert.textFields?[1].text{
                    if let sku = consumableAlert.textFields?[2].text{
                        if type != "" && count != "" && sku != ""{
                            if(Int(count) != nil){
                                if(self.isDuplication(type: type)){
                                    self.present(self.methods.displayAlert(givenTitle: "Error adding - Duplication", givenMessage: "That adapter type is already on this list"), animated: true)
                                }else{
                                    self.fireBaseMethods.addConsumableToFirebase(type: type, count: count, sku: sku)
                                    self.consumableTable.reloadData()
                                }
                            }else{
                                self.present(self.methods.displayAlert(givenTitle: "Error adding - NaN", givenMessage: "\(count) is not a number, please enter a number and try again"), animated: true)
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
    
    //--------------------- CHECK FOR DUPLICATIONS ------------------//
    public func isDuplication(type:String) -> Bool{
        for consumable in consumableArray{
            if(consumable.getType().caseInsensitiveCompare(type) == .orderedSame){ //are equal
                return true
            }
        }
        return false
    }
    
    //---------------------- DELETE FROM TABLE ----------------------//
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        fireBaseMethods.removeConsumableFromFirebase(type: consumableArray[indexPath.row].getType())
        consumableArray.remove(at: indexPath.row)
        self.reloadTable()
    }
    
    //---------------------- EDIT CELLS IN TABLE ----------------------//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editConsumable = UIAlertController(title: "Change Count", message: nil, preferredStyle: .alert)
        editConsumable.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editConsumable.addTextField(configurationHandler: {
            textField in
            textField.keyboardType = .numberPad
            textField.text = self.consumableArray[indexPath.row].getCount()
        })
        
        editConsumable.addTextField(configurationHandler: {
            textField in
            textField.text = self.consumableArray[indexPath.row].getType()
        })
        
        editConsumable.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let count = editConsumable.textFields?[0].text{
                if let type = editConsumable.textFields?[1].text{
                    self.fireBaseMethods.editConsumable(type: self.consumableArray[indexPath.row].getType(), Sku: self.consumableArray[indexPath.row].getSku(), newCount: count, newType: type)
                    
                    self.consumableArray.remove(at: indexPath.row)
                    
                    self.reloadTable()
                    
                }else{
                    self.present(self.methods.displayAlert(givenTitle: "Error adding - Count must be a number", givenMessage: "\(count) is not a number"), animated: true)
                }
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
            }
        }))
        
        self.present(editConsumable, animated: true)
        
    }
    
    //---------------------- FUNCTIONS FOR TABLE VIEW CELLS & TABLE ----------------------//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consumableCell", for: indexPath) as! ConsumablesCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.white
        cell.adapterType.text = consumableArray[indexPath.row].getType()
        cell.count.text = String(consumableArray[indexPath.row].getCount())
        
        if Int(consumableArray[indexPath.row].getCount()) ?? 0 <= 0{
            cell.count.textColor = UIColor.red
        }else{
            cell.count.textColor = UIColor.black
        }
        
        cell.sku.text = consumableArray[indexPath.row].getSku()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
