//
//  CheckedOutDetailViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class CheckedOutDetailViewController: UIViewController {

    var selectedCheckedOutItem: CheckedOut?
    private var methods:MethodsForController = MethodsForController()
    
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
        //signitureImage.image = UIImage(data: (selectedCheckedOutItem?.getSigniture())!, scale:1.0)!
    }
}
