//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Laura Ghiorghisor on 18/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        // table view???????? where from????
        tableView.rowHeight = 80.0
        //adding the colors means no separator is needed
        tableView.separatorStyle = .none
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navigation controller does not exist")
        }
        navBar.backgroundColor = UIColor(hexString: "#FFFFFF")
        if let navBGColor = navBar.backgroundColor {
        navBar.tintColor = ContrastColorOf(navBGColor, returnFlat: true)
         navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBGColor, returnFlat: true)]
        }
//        ??
//       tableView.insetsContentViewsToSafeArea = true
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // overrides the super class methods, takes the cell from there. 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name 
//         use the new chameleon framework
            guard let bgCol = UIColor(hexString: category.bgColor) else { fatalError()}
        cell.backgroundColor = bgCol
        cell.textLabel?.textColor = ContrastColorOf(bgCol, returnFlat: true)

        //UIColor.randomFlat()
        // in order to persist the colors we need to add them as attr/props. -> must save them as hex values, as the realm only accepts standard data types, not UIColor.
        } else  {
            cell.textLabel?.text = "No categories added yet."
        }
            return cell
        
    }
    
    
    //MARK: - Data Manipulaiton Methods - save and load = CRUD
    
    func load() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving cat \(error)")
        }
        tableView.reloadData()
    }
    
    // delete
    override func delete(at indexPath: IndexPath) {
        if let selectedCat = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(selectedCat)
                }
            } catch {
                print("Error deleting cat \(error)")
            }
            //                tableView.reloadData()
            // not needed anymore?
        }  else {
            print("nothing selected error")
        }
    }
    
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var tf = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        // this is the name of the button
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //            let newCategory = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = tf.text!
            newCategory.bgColor = UIColor.randomFlat().hexValue()
            //            self.categories.append(newCategory)
            //not needed as it auto updates 
            self.save(category: newCategory)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                   print("cat alert closed")
               }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New category"
            tf = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        // get the currently selected category
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
    }
}

//MARK: - Swipe cell delegate methods
//extension CategoryViewController: SwipeTableViewCellDelegate {
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            print("item deleted")
//            if let selectedCat = self.categories?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(selectedCat)
//                    }
//                } catch {
//                    print("Error deleting cat \(error)")
//                }
////                tableView.reloadData()
//                // not needed anymore?
//            }  else {
//                print("nothing selected error")
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")
//
//        return [deleteAction]
//    }
//
//        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//            var options = SwipeOptions()
//            options.expansionStyle = .destructive
////            options.transitionStyle = .border
//            return options
//        }
//
//}
