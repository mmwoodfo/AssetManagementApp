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
        let sendTo = "jakexod573@mailrunner.net"
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([sendTo])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            self.present(methods.displayAlert(givenTitle: "ERROR", givenMessage: "here was a problem sending your email to \(sendTo)"), animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //---------------------- DELETE FROM TABLE ----------------------//
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let deleteAlert = UIAlertController(title: "ARE YOU SURE YOU WANT TO DELETE \(consumableArray[indexPath.row].getType()) CONSUMABLE?", message: nil, preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        deleteAlert.addAction(UIAlertAction(title: "Yes, Delete", style: .destructive, handler: {
            action in
            self.consumableDictionary[self.consumableArray[indexPath.row].getType()] = "DELETE"
            self.consumableArray.remove(at: indexPath.row)
            self.consumableTable.reloadData()
        }))
        
        self.present(deleteAlert, animated: true)
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
                self.consumableDictionary[self.consumableArray[indexPath.row].getType()] = count
                self.consumableTable.reloadData()
                    
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
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
