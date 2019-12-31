//
//  AssignedDetailViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/22/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class AssignedDetailViewController: UIViewController {

    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    private var methods:MethodsForController = MethodsForController()
    
    var selectedAssignedItem: Assigned?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var asurite: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var adapterType: UILabel!
    @IBOutlet weak var adapterCount: UILabel!
    @IBOutlet weak var assignedDate: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var ticketNumber: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        name.text = selectedAssignedItem?.getName()
        asurite.text = selectedAssignedItem?.getAsuriteId()
        email.text = selectedAssignedItem?.getEmail()
        phoneNumber.text = selectedAssignedItem?.getPhone()
        adapterType.text = selectedAssignedItem?.getAdaptorType()
        adapterCount.text = selectedAssignedItem?.getCount()
        assignedDate.text = selectedAssignedItem?.getLoanedDate()
        ticketNumber.text = selectedAssignedItem?.getTicketNumber()
        reason.text = selectedAssignedItem?.getReason()
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
                self.fireBaseMethods.updateAssignedTicket(asuriteId: self.asurite.text ?? "", adapterType: self.adapterType.text ?? "", loanedDate: self.assignedDate.text ?? "", newTicketID: ticket)
                
                self.ticketNumber.text = ticket
                
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Error adding - Please fill out all fields", givenMessage: ""), animated: true)
            }
        }))
        
        self.present(editTicketNumber, animated: true)  
    }
}
