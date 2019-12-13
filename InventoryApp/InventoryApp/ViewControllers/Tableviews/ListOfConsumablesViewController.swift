//
//  ListOfConsumablesViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit
import Firebase

class ListOfConsumablesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var methods:MethodsForController = MethodsForController()
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    private var consumableArray = [Consumable]()
    private var ref:DatabaseReference?
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var consumableTable: UITableView!
    
    //========================VIEW DID LOAD=======================//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        populateConsumableArray()
        
        self.consumableTable.dataSource = self
        self.consumableTable.delegate = self
    }
    
    //======================= Reload Table ==============================//
    func reloadTable(){
        consumableArray.sort{ ($0.getType()) < ($1.getType()) }
        self.consumableTable.reloadData()
    }
    
    //========================POPULATE CONSUMABLE ARRAY=======================//
    func populateConsumableArray(){
        //let the object populate itself.
        self.ref?.child("Consumables").observe(.childAdded, with: { [weak self] snapshot in
            guard let self = self else { return }
            let dataChange = snapshot.value as? [String:AnyObject]
            let aRequest = Consumable(aDict: dataChange!)
            self.consumableArray.append(aRequest)
            
            self.reloadTable()
        })
    }
    
    //===========================Functions for Table view Cells and the Table=======================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(consumableArray.count)
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
    
    //=============== Delete From Table  ======================
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let refToDelete = self.ref?.child("Consumables").child(consumableArray[indexPath.row].getType())
        refToDelete?.removeValue()
        consumableArray.remove(at: indexPath.row)
        self.reloadTable()
    }
    
    //=============== EDIT CELLS IN TABLE  ======================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editConsumableCount = UIAlertController(title: "Change Count", message: nil, preferredStyle: .alert)
        editConsumableCount.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editConsumableCount.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Consumable Count"
        })
        
        editConsumableCount.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let count = editConsumableCount.textFields?[0].text{
                if Int(count) != nil {
                    self.ref?.child("Consumables").child(self.consumableArray[indexPath.item].getType()).child("Count").setValue(count)
                    self.consumableArray[indexPath.item].setCount(count: count)
                    
                    self.reloadTable()
                    
                }else{
                    self.present(self.methods.displayAlert(givenTitle: "Error adding - Count must be a number", givenMessage: "\(count) is not a number"), animated: true)
                }
            }
        }))
        
        self.present(editConsumableCount, animated: true)
        
    }
    
    //=============== ADD CELLS TO TABLE  ======================
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
            if let type = consumableAlert.textFields?[0].text{
                if let count = consumableAlert.textFields?[1].text{
                    if let sku = consumableAlert.textFields?[2].text{
                        if type != "" && count != "" && sku != ""{
                            if(Int(count) != nil){
                                self.fireBaseMethods.addConsumableToFirebase(type: type, count: count, sku: sku, ref: self.ref!)
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
}
