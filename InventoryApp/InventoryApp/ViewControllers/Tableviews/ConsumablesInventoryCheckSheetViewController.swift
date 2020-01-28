//
//  ConsumablesInventoryCheckSheetViewController.swift
//  InventoryApp
//
//  Created by Meghan on 1/28/20.
//  Copyright © 2020 Herberger IT. All rights reserved.
//

import UIKit
import MessageUI

class ConsumablesInventoryCheckSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    private var methods:MethodsForController = MethodsForController()
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    private var consumableArray = [Consumable]()
    private var consumableDictionary: [String:String] = [:]
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var consumableTable: UITableView!
    
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
    
    //----------- FINISHED REVIEWING CONSUMABLES INVENTORY BUTTON --------------//
    @IBAction func doneReviewingBtn(_ sender: Any) {
        if(consumableArray.count != consumableDictionary.count){
            self.present(methods.displayAlert(givenTitle: "Inventory Incomplete", givenMessage: "Please fill out count for all inventory items"), animated: true)
        }else{
            let signOffAlert = UIAlertController(title: "Update Inventory & Email Changes", message: "Please sign your name below", preferredStyle: .alert)
            signOffAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            signOffAlert.addTextField(configurationHandler: {
                textField in
            })
            
            signOffAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
                action in
                if let eSigniture = signOffAlert.textFields?[0].text{
                    
                    //update firebase inventory
                    self.fireBaseMethods.updateInventoryFromCheck(consumableArray: self.consumableArray, consumableDictionary: self.consumableDictionary)
                    
                    let sendTo = "hidacs@asu.edu"
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setToRecipients([sendTo])
                        mail.setSubject("Inventory Update by \(eSigniture)")
                        mail.setMessageBody(self.methods.htmlEmailFormat(eSigniture: eSigniture, consumableArray: self.consumableArray, consumableDictionary: self.consumableDictionary), isHTML: true)
                        
                        self.present(mail, animated: true)
                        
                    } else {
                        self.present(self.methods.displayAlert(givenTitle: "ERROR", givenMessage: "There was a problem sending your email to \(sendTo)"), animated: true)
                    }
                }else{
                    self.present(self.methods.displayAlert(givenTitle: "Error", givenMessage: "Try again and fill out your name"), animated: true)
                }
            }))
            
            self.present(signOffAlert, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //---------------------- EDIT CELLS IN TABLE ----------------------//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editConsumable = UIAlertController(title: "Change Count of \(consumableArray[indexPath.row].getType())", message: nil, preferredStyle: .alert)
        editConsumable.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editConsumable.addTextField(configurationHandler: {
            textField in
            textField.keyboardType = .numberPad
        })
        
        editConsumable.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let count = editConsumable.textFields?[0].text{
                if((Int(count)) != nil){
                    self.consumableDictionary[self.consumableArray[indexPath.row].getType()] = count
                    self.consumableTable.reloadData()
                }else{
                    self.present(self.methods.displayAlert(givenTitle: "Error editing", givenMessage: "Please enter a number"), animated: true)
                }
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error editing", givenMessage: "Do not leave blank"), animated: true)
            }
        }))
        
        self.present(editConsumable, animated: true)
        
    }
    
    //----------------- TABLE VIEW FUNCTIONS --------------------------//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consumableCell", for: indexPath) as! ConsumableCheckerCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.white
        cell.adapterType.text = consumableArray[indexPath.row].getType()
        cell.expectedCount.text = String(consumableArray[indexPath.row].getCount())
        cell.actualCount.text = self.consumableDictionary[self.consumableArray[indexPath.row].getType()]
        
        if Int(consumableArray[indexPath.row].getCount()) ?? 0 <= 0{
            cell.expectedCount.textColor = UIColor.red
        }else{
            cell.expectedCount.textColor = UIColor.black
        }
        
        cell.sku.text = consumableArray[indexPath.row].getSku()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
