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
    private var fireBaseMethods:FireBaseMethods = FireBaseMethods()
    
    private var checkedOutAdapterArray = [CheckedOut]()
    
    //-------------------- VIEW DID LOAD -----------------------//
    override func viewDidLoad()
    {
        checkedOutAdapterArray = fireBaseMethods.populateCheckedOutTableArray()
        checkedOutTable.reloadData()
        
        self.checkedOutTable.dataSource = self
        self.checkedOutTable.delegate = self
        
        super.viewDidLoad()
    }
    
    //--------------------------- SORTS BY ASCENDING ----------------------------------//
    @IBAction func SortListAscending(_ sender: Any) {
        let sortAlert = UIAlertController(title: "Sort List", message: "Sort the list by:", preferredStyle: .alert)
        sortAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sortAlert.addAction(UIAlertAction(title: "Name", style: .default, handler: {
            action in
            self.checkedOutAdapterArray.sort {
                $0.getName().lowercased() < $1.getName().lowercased()
            }
            
            self.checkedOutTable.reloadData()
        }))
        
        sortAlert.addAction(UIAlertAction(title: "Adapter", style: .default, handler: {
            action in
            self.checkedOutAdapterArray.sort {
                $0.getAdaptorType().lowercased() < $1.getAdaptorType().lowercased()
            }
            
            self.checkedOutTable.reloadData()
        }))
        
        sortAlert.addAction(UIAlertAction(title: "Date", style: .default, handler: {
            action in
            self.checkedOutAdapterArray.sort {
                $0.getLoanedDate() < $1.getLoanedDate()
            }
            
            self.checkedOutTable.reloadData()
        }))
        
        self.present(sortAlert, animated: true)
    }
    
    //------------------------------- SEARCH --------------------------------------//
    @IBAction func SearchConsumable(_ sender: Any) {
        let searchAlert = UIAlertController(title: "Search List", message: "Search the list by borrowers name", preferredStyle: .alert)
        searchAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        searchAlert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Name of borrower"
        })
        
        searchAlert.addAction(UIAlertAction(title: "Search", style: .default, handler: {
            action in
            if let name = searchAlert.textFields?[0].text{
                var searchedItems = [CheckedOut]()
                for item in self.checkedOutAdapterArray{
                    if item.getName().lowercased() == name.lowercased(){
                        searchedItems.append(item)
                    }
                }
                
                if !searchedItems.isEmpty{
                    self.checkedOutAdapterArray = searchedItems
                    self.checkedOutTable.reloadData()
                }else{
                    self.present(self.methods.displayAlert(givenTitle: "No results found for \(name)", givenMessage:"Please check the spelling and try again"), animated: true)
                }
                
            }else{
                self.present(self.methods.displayAlert(givenTitle: "Name field left blank", givenMessage:"Please specify a name and try again"), animated: true)
            }
        }))
        
        self.present(searchAlert, animated: true)
    }
    
    //------------------------------- UNWIND SEGUE --------------------------------------//
    @IBAction func unwindToCheckedOutList(_ sender: UIStoryboardSegue){}
    
    //---------------------- DELETE FROM TABLE ----------------------//
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        fireBaseMethods.removeCheckedOutFromFirebase(name: checkedOutAdapterArray[indexPath.row].getName(), type: checkedOutAdapterArray[indexPath.row].getAdaptorType())
        checkedOutAdapterArray.remove(at: indexPath.row)
        
        checkedOutTable.reloadData()
    }
    
    //-------------- SHOW CELL DETAILS ON DETAILS PAGE ------------------//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "CheckedoutToDetailed"
        {
            let selectedIndex: IndexPath = self.checkedOutTable.indexPath(for: sender as! UITableViewCell)!
            let checkedOutItem = checkedOutAdapterArray[selectedIndex.row]
            
            if let viewController: CheckedOutDetailViewController = segue.destination as? CheckedOutDetailViewController
            {
                viewController.selectedCheckedOutItem = checkedOutItem
                print("Going to detailed view")
            }
        }
    }
    
    //---------------------- FUNCTIONS FOR TABLE VIEW CELLS & TABLE ----------------------//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return checkedOutAdapterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckedOutCell", for: indexPath) as! CheckOutCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = UIColor.white
        cell.name.text = checkedOutAdapterArray[indexPath.row].getName()
        cell.returnDate.text = checkedOutAdapterArray[indexPath.row].getExpectedReturnDate()
        cell.adapterType.text = checkedOutAdapterArray[indexPath.row].getAdaptorType()
        cell.reason.text = checkedOutAdapterArray[indexPath.row].getReason()
        
        if methods.checkOverdue(dateStr: checkedOutAdapterArray[indexPath.row].getExpectedReturnDate())
        {
            cell.returnDate.textColor = UIColor.red
        }else{
            cell.returnDate.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
}
