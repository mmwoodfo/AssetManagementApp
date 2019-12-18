//
//  ViewController.swift
//  InventoryApp
//
//  Created by Meghan on 10/23/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnCheckout.layer.cornerRadius = 10
        btnConsumables.layer.cornerRadius = 10
        btnView.layer.cornerRadius = 10
        
        hidaLogo.image = UIImage(named: "HIDA logo")
        
        fireBaseMethods.removeObservers()
    }
    
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var btnConsumables: UIButton!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var hidaLogo: UIImageView!
}

