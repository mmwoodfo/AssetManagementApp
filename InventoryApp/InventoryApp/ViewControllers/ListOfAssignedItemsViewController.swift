//
//  ListOfAssignedItemsViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class ListOfAssignedItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var assignedTable: UITableView!
    
   private var methods:MethodsForController = MethodsForController()
   private var assignedAdapterArray = [AssignedEntity]()
   
   override func viewDidLoad() {
       
       populateAssignedAdapterArray()
       
       self.assignedTable.dataSource = self
       self.assignedTable.delegate = self
       
       super.viewDidLoad()

       // Do any additional setup after loading the view.
   }
   
   //---------------------- POPULATE ADAPTER ARRAY --------------------------------//
   public func populateAssignedAdapterArray() {
       assignedAdapterArray = methods.fetchAssignedEntity()
   }
   
   //===========================Functions for Table view Cells and the Table=======================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedAdapterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignedCell", for: indexPath) as! AssignedCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.white
        cell.name.text = assignedAdapterArray[indexPath.item].name
        cell.adapter.text = assignedAdapterArray[indexPath.item].adaptorName
        cell.reason.text = assignedAdapterArray[indexPath.item].reason
        return cell
    }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 90
   }
   
   func reloadTableView(){
       populateAssignedAdapterArray()
       assignedTable.reloadData()
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
       let cell = self.assignedTable.cellForRow(at: indexPath) as! AssignedCell?
       if methods.IncreaseConsumableCount(consumableName: cell?.adapter.text ?? ""){
           print("Count increased")
       }else{
           print("Error, could not increase count")
       }
       methods.deleteAssignedEntity(entity: assignedAdapterArray[indexPath.row])
       reloadTableView()
   }
   
    //------------------------------- UNWIND SEGUE --------------------------------------//
    @IBAction func unwindToAssignedList(_ sender: UIStoryboardSegue) {
        
    }
    
   //-------------- SHOW CELL DETAILS ON DETAILS PAGE ------------------//
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "AssignedToDetails"{
           let selectedIndex: IndexPath = self.assignedTable.indexPath(for: sender as! UITableViewCell)!
           let assignedItem = assignedAdapterArray[selectedIndex.row]
           
           if let viewController: AssignedDetailViewController = segue.destination as? AssignedDetailViewController {
               viewController.selectedAssignedItem = assignedItem
               print("Going to detailed view")
           }
       }
   }
}
