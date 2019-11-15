//
//  AssignedCheckedOutViewController.swift
//  InventoryApp
//
//  Created by Meghan on 10/23/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class ListOfCheckedOutItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var checkedOutTable: UITableView!
    
    private var methods:MethodsForController = MethodsForController()
    private var checkedOutAdapterArray = [CheckoutEntity]()
    
    override func viewDidLoad() {
        
        checkedOutAdapterArray = methods.fetchCheckedoutEntity()
        
        self.checkedOutTable.dataSource = self
        self.checkedOutTable.delegate = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //===========================Functions for Table view Cells and the Table=======================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckedOutCell", for: indexPath) as! CheckOutCell
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor.green
        cell.name.text = checkedOutAdapterArray[indexPath.row].name

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
