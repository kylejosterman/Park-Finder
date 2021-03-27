//
//  ParkFinderViewController.swift
//  Park Finder
//
//  Created by Kyle Osterman on 3/27/21.
//

import UIKit
import CoreData
import CoreLocation

class ParkFinderViewController: UITableViewController {
    var arr = [Item()]
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkItemCell", for: indexPath)
        let item = arr[indexPath.row]
        cell.textLabel?.text = item.parkName
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(arr[indexPath.row])
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
}
