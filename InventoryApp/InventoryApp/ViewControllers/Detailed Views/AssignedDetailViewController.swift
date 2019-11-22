//
//  AssignedDetailViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/22/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class AssignedDetailViewController: UIViewController {

    var selectedAssignedItem: AssignedEntity?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var asurite: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var adapterType: UILabel!
    @IBOutlet weak var assignedDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = selectedAssignedItem?.name
        asurite.text = selectedAssignedItem?.asuriteId
        email.text = selectedAssignedItem?.email
        phoneNumber.text = selectedAssignedItem?.phoneNumber
        adapterType.text = selectedAssignedItem?.adaptorName
        assignedDate.text = selectedAssignedItem?.loanedDate
    }
}
