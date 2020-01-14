//
//  CheckedOutDetailViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit
import Firebase
import AnyFormatKit

class CheckedOutDetailViewController: UIViewController {

    var selectedCheckedOutItem: CheckedOut?
    private var methods:MethodsForController = MethodsForController()
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var asurite: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var adapterType: UILabel!
    @IBOutlet weak var adapterCount: UILabel!
    @IBOutlet weak var loanedDate: UILabel!
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var ticketNumber: UILabel!
    @IBOutlet weak var signitureImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        name.text = selectedCheckedOutItem?.getName()
        asurite.text = selectedCheckedOutItem?.getAsuriteId()
        email.text = selectedCheckedOutItem?.getEmail()
        phoneNumber.text = selectedCheckedOutItem?.getPhone()
        adapterType.text = selectedCheckedOutItem?.getAdaptorType()
        adapterCount.text = selectedCheckedOutItem?.getCount()
        loanedDate.text = selectedCheckedOutItem?.getLoanedDate()
        returnDate.text = selectedCheckedOutItem?.getExpectedReturnDate()
        ticketNumber.text = selectedCheckedOutItem?.getTicketNumber()
        reason.text = selectedCheckedOutItem?.getReason()
        
        let storage = Storage.storage()
        var reference: StorageReference!
        
        reference = storage.reference(forURL: selectedCheckedOutItem?.getSigniture() ?? "")
        reference.downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.signitureImage.image = image
        }
    }

//=============== Edit Information =================//
    //EDIT TICKET
    @IBAction func editTicketNumber(_ sender: Any) {
        let editTicketNumber = UIAlertController(title: "Edit Ticket Number", message: nil, preferredStyle: .alert)
        editTicketNumber.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editTicketNumber.addTextField(configurationHandler: {
            textField in
            textField.keyboardType = .numberPad
            textField.text = self.ticketNumber.text
        })
        
        editTicketNumber.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let ticket = editTicketNumber.textFields?[0].text {
                self.fireBaseMethods.updateCheckedOutTicket(asuriteId: self.asurite.text ?? "", expectedReturn: self.returnDate.text ?? "", adapterType: self.adapterType.text ?? "", loanedDate: self.loanedDate.text ?? "", newTicketID: ticket)
                
                self.ticketNumber.text = ticket
                
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
            }
        }))
        
        self.present(editTicketNumber, animated: true)
    }
    //EDIT NAME
    @IBAction func editName(_ sender: Any) {
        let editName = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)
        editName.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editName.addTextField(configurationHandler: {
            textField in
            textField.text = self.name.text
        })
        
        editName.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let name = editName.textFields?[0].text {
                self.fireBaseMethods.updateCheckedOutName(asuriteId: self.asurite.text ?? "", expectedReturn: self.returnDate.text ?? "", adapterType: self.adapterType.text ?? "", loanedDate: self.loanedDate.text ?? "", newName: name)
                
                self.name.text = name
                
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
            }
        }))
        
        self.present(editName, animated: true)
    }
    //EDIT EMAIL
    @IBAction func editEmail(_ sender: Any) {
        let editEmail = UIAlertController(title: "Edit E-mail", message: nil, preferredStyle: .alert)
        editEmail.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editEmail.addTextField(configurationHandler: {
            textField in
            textField.text = self.email.text
        })
        
        editEmail.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let email = editEmail.textFields?[0].text {
                if(self.methods.checkEmail(email: email)){
                    self.fireBaseMethods.updateCheckedOutEmail(asuriteId: self.asurite.text ?? "", expectedReturn: self.returnDate.text ?? "", adapterType: self.adapterType.text ?? "", loanedDate: self.loanedDate.text ?? "", newEmail: email)
                    
                    self.email.text = email
                }
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
            }
        }))
        
        self.present(editEmail, animated: true)
    }
    //EDIT PHONE
    @IBAction func editPhone(_ sender: Any) {
        let editPhone = UIAlertController(title: "Edit Phone Number", message: nil, preferredStyle: .alert)
        editPhone.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editPhone.addTextField(configurationHandler: {
            textField in
            textField.text = self.phoneNumber.text
        })
        
        editPhone.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let phone = editPhone.textFields?[0].text {
                self.fireBaseMethods.updateCheckedOutPhoneNumber(asuriteId: self.asurite.text ?? "", expectedReturn: self.returnDate.text ?? "", adapterType: self.adapterType.text ?? "", loanedDate: self.loanedDate.text ?? "", newPhoneNumber: phone)
                    
                self.phoneNumber.text = phone
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
            }
        }))
        
        self.present(editPhone, animated: true)
    }
    
}
