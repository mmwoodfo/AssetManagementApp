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
        
        populateAdapterArray()
        
        self.checkedOutTable.dataSource = self
        self.checkedOutTable.delegate = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   //------------------------------- UNWIND SEGUE --------------------------------------//
   @IBAction func unwindToCheckedOutList(_ sender: UIStoryboardSegue) {
       
   }
    
    //---------------------- POPULATE ADAPTER ARRAY --------------------------------//
    public func populateAdapterArray() {
        checkedOutAdapterArray = methods.fetchCheckedoutEntity()
    }
    
    //===========================Functions for Table view Cells and the Table=======================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckedOutCell", for: indexPath) as! CheckOutCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.white
        cell.name.text = checkedOutAdapterArray[indexPath.row].name
        cell.returnDate.text = checkedOutAdapterArray[indexPath.row].expectedReturnDate
        cell.adapterType.text = checkedOutAdapterArray[indexPath.row].adaptorName
        cell.reason.text = checkedOutAdapterArray[indexPath.row].reason

        if methods.checkOverdue(dateStr: checkedOutAdapterArray[indexPath.row].expectedReturnDate ?? ""){
            cell.returnDate.textColor = UIColor.red
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func reloadTableView(){
        populateAdapterArray()
        checkedOutTable.reloadData()
    }
    
    //=============== Delete From Table  ======================
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        methods.deleteCheckedoutEntity(entity: checkedOutAdapterArray[indexPath.row])
        reloadTableView()
    }
    
    //-------------- SHOW CELL DETAILS ON DETAILS PAGE ------------------//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCheckedOutView"{
            let selectedIndex: IndexPath = self.checkedOutTable.indexPath(for: sender as! UITableViewCell)!
            let checkedOutItem = checkedOutAdapterArray[selectedIndex.row]
            
            if let viewController: CheckedOutDetailViewController = segue.destination as? CheckedOutDetailViewController {
                viewController.selectedCheckedOutItem = checkedOutItem
                print("Going to detailed view")
            }
        }
    }

}
