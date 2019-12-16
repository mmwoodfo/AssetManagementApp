//
//  ListOfAssignedItemsViewController.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class ListOfAssignedItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var assignedTable: UITableView!
    
    private var methods:MethodsForController = MethodsForController()
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    private var assignedAdapterArray = [Assigned]()
    
    //-------------------- VIEW DID LOAD -----------------------//
    override func viewDidLoad(){
        
        assignedAdapterArray = fireBaseMethods.populateAssignedTableArray()
        assignedTable.reloadData()
        
        self.assignedTable.dataSource = self
        self.assignedTable.delegate = self
        
        super.viewDidLoad()
    }
    
    //--------------------------- SORTS BY ASCENDING ----------------------------------//
    @IBAction func SortListAscending(_ sender: Any) {
        let sortAlert = UIAlertController(title: "Sort List", message: "Sort the list by:", preferredStyle: .alert)
        sortAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sortAlert.addAction(UIAlertAction(title: "Name", style: .default, handler: {
            action in
            self.assignedAdapterArray.sort {
                $0.getName().lowercased() < $1.getName().lowercased()
            }
            
            self.assignedTable.reloadData()
        }))
        
        sortAlert.addAction(UIAlertAction(title: "Adapter", style: .default, handler: {
            action in
            self.assignedAdapterArray.sort {
                $0.getAdaptorType().lowercased() < $1.getAdaptorType().lowercased()
            }
            
            self.assignedTable.reloadData()
        }))
        self.present(sortAlert, animated: true)
    }
    
    //------------------------------- SEARCH --------------------------------------//
    @IBAction func SearchAssigned(_ sender: Any) {
        let searchAlert = UIAlertController(title: "Search List", message: "Search the list by borrowers name", preferredStyle: .alert)
        searchAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        searchAlert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Name of borrower"
        })
        
        searchAlert.addAction(UIAlertAction(title: "Search", style: .default, handler: {
            action in
            if let name = searchAlert.textFields?[0].text{
                var searchedItems = [Assigned]()
                for item in self.assignedAdapterArray{
                    if item.getName().lowercased() == name.lowercased(){
                        searchedItems.append(item)
                    }
                }
                
                if !searchedItems.isEmpty{
                    self.assignedAdapterArray = searchedItems
                    self.assignedTable.reloadData()
                }else{
                    self.present(self.methods.displayAlert(givenTitle: "No results found for \(name)", givenMessage:"Please check the spelling and try again"), animated: true)
                }
                
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Name field left blank", givenMessage:"Please specify a name and try again"), animated: true)
            }
        }))
        
        self.present(searchAlert, animated: true)
    }
    
    //---------------------- DELETE FROM TABLE ----------------------//
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle{
        return UITableViewCell.EditingStyle.delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        fireBaseMethods.removeAssignedFromFirebase(name: assignedAdapterArray[indexPath.row].getName(), type: assignedAdapterArray[indexPath.row].getAdaptorType())
        assignedAdapterArray.remove(at: indexPath.row)
        
        self.assignedTable.reloadData()
    }
    
    //------------------------------- UNWIND SEGUE --------------------------------------//
    @IBAction func unwindToAssignedList(_ sender: UIStoryboardSegue) {}
    
    //-------------- SHOW CELL DETAILS ON DETAILS PAGE ------------------//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AssignedToDetails"{
            let selectedIndex: IndexPath = self.assignedTable.indexPath(for: sender as! UITableViewCell)!
            let assignedItem = assignedAdapterArray[selectedIndex.row]
            
            if let viewController: AssignedDetailViewController = segue.destination as? AssignedDetailViewController{
                viewController.selectedAssignedItem = assignedItem
                print("Going to detailed view")
            }
        }
    }
    
    //---------------------- FUNCTIONS FOR TABLE VIEW CELLS & TABLE ----------------------//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return assignedAdapterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignedCell", for: indexPath) as! AssignedCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.white
        cell.name.text = assignedAdapterArray[indexPath.item].getName()
        cell.adapter.text = assignedAdapterArray[indexPath.item].getAdaptorType()
        cell.reason.text = assignedAdapterArray[indexPath.item].getReason()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 90
    }
}
