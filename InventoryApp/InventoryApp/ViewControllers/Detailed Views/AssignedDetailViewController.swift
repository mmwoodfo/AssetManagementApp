//
//  AssignedDetailViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/22/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class AssignedDetailViewController: UIViewController {

    var selectedAssignedItem: Assigned?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var asurite: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var adapterType: UILabel!
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
        assignedDate.text = selectedAssignedItem?.getLoanedDate()
        ticketNumber.text = selectedAssignedItem?.getTicketNumber()
        reason.text = selectedAssignedItem?.getReason()
    }
}
