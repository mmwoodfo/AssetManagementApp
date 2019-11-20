//
//  CheckedOutDetailViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class CheckedOutDetailViewController: UIViewController {

    var selectedCheckedOutItem: CheckoutEntity?
    private var methods:MethodsForController = MethodsForController()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var asurite: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var adapterType: UILabel!
    @IBOutlet weak var loanedDate: UILabel!
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var reason: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = selectedCheckedOutItem?.name
        asurite.text = selectedCheckedOutItem?.asuriteId
        email.text = selectedCheckedOutItem?.email
        phoneNumber.text = selectedCheckedOutItem?.phoneNumber
        adapterType.text = selectedCheckedOutItem?.adaptorName
        loanedDate.text = selectedCheckedOutItem?.loanedDate
        returnDate.text = selectedCheckedOutItem?.expectedReturnDate
        reason.text = selectedCheckedOutItem?.reason
        
        //if true, change return date text to red
        if methods.checkOverdue(dateStr: returnDate.text ?? ""){
            returnDate.textColor = UIColor.red
        }
    }

}