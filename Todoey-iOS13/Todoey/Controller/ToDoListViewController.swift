//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//



/// using floats for volume
// string player name
// date last opened
// bool music on or off
//defaults.set(Date(), forkye: "Lastopened:)
// or set array.
// then let arr = defaults. array/float. etc

// !!!!! User defaults is a singleton
// sharedURLSession - URLSession,shared

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //    var itemArray = ["Seek", "Destroy", "Seek and Destroy"]
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            // when cat is set 
            load()
        }
    }
    // used for plist
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // this context is used to save items to coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    let defaults = UserDefaults.standard
    // this stores persistent key values pairs across the cycle of the app
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // you can also drag an arrow from the searh bar tp the controller 
        searchBar.delegate = self
        
           // this is where the DB will live, as above with the plist,  but the path will be different; LIBRARY, APPLICATION SUPPORT -- DATAMODEL.sqlite
           print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
//        let item1 = Item()
//        item1.title = "Seek"
//        let item2 = Item()
//        item2.title = "Destroy"
//        let item3 = Item()
//        item3.title = "Seek and destroy"
//
//        itemArray.append(item1)
//        itemArray.append(item2)
//        itemArray.append(item3)
        
        
        //        if let safeItems = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //                   itemArray = safeItems
        //               } else {
        //                   print ("NOT RETRIEVED")
        //               }
        
        // Do any additional setup after loading the view.
        
        // this isnt needed here anymore as it's called when cat gets set
        load()
    }
    
    // Mark - Tableview Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // setting the checkmarks
        //TERNARY OPERATOR
        // value = cond? val1 : val2
        
        cell.accessoryType = (item.done == true) ? .checkmark : .none
        //  cell.accessoryType = item.done ? .checkmark : .none
        //         if item.done == true
        //        {
        //           cell.accessoryType = .checkmark
        //        } else {
        //           cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    
    
    // MARK - tv delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        print (indexPath.row, self.itemArray[indexPath.row])
        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        //DELETE
        // ORDER VERY IMPORTANT
//           context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
        item.setValue("completed", forKey: "title")
        
        //same as
        //        if itemArray[indexPath.row].done == true {
        //            itemArray[indexPath.row].done = false
        //        } else {
        //            itemArray[indexPath.row].done = true
        //        }
        
        //now done in the cellforrow
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.save()
        tableView.reloadData()
        
    }
    
    
    // MARK - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var tf = UITextField()
        // will have an alert/pop up
        
        let alert = UIAlertController(title: "Add To Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // what happens after add
            if let safeText = tf.text {
                // this item will now be generated based on the Item entity
//                let newItem = Item()
              
                let newItem = Item(context: self.context)
                newItem.title = safeText
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                //                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                // save the item as encoded in a new plist of our own making
                self.save()
                
                self.tableView.reloadData()
            }
        }
        // add tf to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New item"
            tf = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func save () {
        // plist encoder way
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print ("error encoding, \(error)")
//        }
        do {
            try  self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
       
    }

    // has a default calue for the viewDidLoad
    // also usage of internal and external parameters
    func load(_ request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // the plist used with user defaults :
//            if let data = try? Data(contentsOf: dataFilePath!) {
//                 let decoder = PropertyListDecoder()
//                do {
//                    self.itemArray = try decoder.decode([Item].self, from: data)
//                }
//                catch {
//                    print("error decoding \(error)")
//                }
//            }
        
        
        // core data storage
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // this needs an extra query now, as to conform to the selectedCategory shabang addition
     
        let categotyPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        // the predicate is now optional. must use optional binding
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categotyPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categotyPredicate
        }
        
        
       
        do {
           itemArray =  try context.fetch(request)
       } catch {
           print("Error fetching\(error)")
       }
        tableView.reloadData()
    }
    
  
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // cd is capital and diacritic insensitive?
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor] // can put on same line with the above
        load(request, predicate: predicate )
        
//        print(searchBar.text!)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
