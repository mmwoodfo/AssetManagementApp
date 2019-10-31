//
//  CheckoutViewController.swift
//  InventoryApp
//
//  Created by Meghan on 10/23/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit
weak var field: UITextField!


class CheckoutViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var asuField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var reasonField: UITextField!
    
    @IBOutlet weak var SuccessLabel: UILabel!
    
    override func viewDidLoad() {
        
        SuccessLabel.isHidden = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func CheckOutItem(_ sender: Any) {
        
        var name: String = nameField.text ?? "null"
        var asuID: String = asuField.text ?? "null"
        var email: String = emailField.text ?? "null"
        var phone: String = phoneField.text ?? "null"
        var reason: String = reasonField.text ?? "null"
        
        SuccessLabel.isHidden = false
        
        
    }
    
    
    @IBAction func ClearFields(_ sender: Any) {
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
