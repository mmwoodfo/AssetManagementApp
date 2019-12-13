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
    
    override func viewDidLoad()
    {
        populateAdapterArray()
        
        self.checkedOutTable.dataSource = self
        self.checkedOutTable.delegate = self
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //--------------------------- SORTS BY ASCENDING ----------------------------------//
    @IBAction func SortListAscending(_ sender: Any) {
        let sortAlert = UIAlertController(title: "Sort List", message: "Sort the list by:", preferredStyle: .alert)
        sortAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sortAlert.addAction(UIAlertAction(title: "Name", style: .default, handler: {
            action in
            self.checkedOutAdapterArray.sort {
                $0.name!.lowercased() < $1.name!.lowercased()
            }
            
            self.checkedOutTable.reloadData()
        }))
        
        sortAlert.addAction(UIAlertAction(title: "Adapter", style: .default, handler: {
            action in
            self.checkedOutAdapterArray.sort {
                $0.adaptorName!.lowercased() < $1.adaptorName!.lowercased()
            }
            
            self.checkedOutTable.reloadData()
        }))
        
        sortAlert.addAction(UIAlertAction(title: "Date", style: .default, handler: {
            action in
            self.checkedOutAdapterArray.sort {
                $0.loanedDate! < $1.loanedDate!
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
                var searchedItems = [CheckoutEntity]()
                for item in self.checkedOutAdapterArray{
                    if item.name!.lowercased() == name.lowercased(){
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
    
    //---------------------- POPULATE ADAPTER ARRAY --------------------------------//
    public func populateAdapterArray()
    {
        checkedOutAdapterArray = methods.fetchCheckedoutEntity()
    }
    
    //===========================Functions for Table view Cells and the Table=======================
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
        cell.name.text = checkedOutAdapterArray[indexPath.row].name
        cell.returnDate.text = checkedOutAdapterArray[indexPath.row].expectedReturnDate
        cell.adapterType.text = checkedOutAdapterArray[indexPath.row].adaptorName
        cell.reason.text = checkedOutAdapterArray[indexPath.row].reason
        
        if methods.checkOverdue(dateStr: checkedOutAdapterArray[indexPath.row].expectedReturnDate ?? "")
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
    
    func reloadTableView()
    {
        populateAdapterArray()
        checkedOutTable.reloadData()
    }
    
    //=============== Delete From Table  ======================
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
        let cell = self.checkedOutTable.cellForRow(at: indexPath) as! CheckOutCell?
        
        //if methods.IncreaseConsumableCount(consumableName: cell?.adapterType.text ?? "")
        //{
          //  print("Count increased")
        //}
        //else
        //{
          //  print("Error, could not increase count")
        //}
        
        methods.deleteCheckedoutEntity(entity: checkedOutAdapterArray[indexPath.row])
        reloadTableView()
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
}
