//
//  CheckedOutDetailViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit
import Firebase

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

    @IBAction func editTicketNumber(_ sender: Any) {
        let editTicketNumber = UIAlertController(title: "Change Ticket Number", message: nil, preferredStyle: .alert)
        editTicketNumber.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editTicketNumber.addTextField(configurationHandler: {
            textField in
            textField.keyboardType = .numberPad
            textField.text = self.ticketNumber.text
        })
        
        editTicketNumber.addAction(UIAlertAction(title: "Update", style: .default, handler: {
            action in
            if let ticket = editTicketNumber.textFields?[0].text {
                //do something
                self.fireBaseMethods.updateCheckedOutTicket(asuriteId: self.asurite.text ?? "", expectedReturn: self.returnDate.text ?? "", adapterType: self.adapterType.text ?? "", loanedDate: self.loanedDate.text ?? "", newTicketID: ticket)
                
                self.ticketNumber.text = ticket
                
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
            }
        }))
        
        self.present(editTicketNumber, animated: true)
    }
}
