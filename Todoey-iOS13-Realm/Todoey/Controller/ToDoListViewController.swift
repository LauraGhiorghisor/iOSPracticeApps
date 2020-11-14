//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//


import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            load()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    var realm = try! Realm()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        load()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
//        if let barTint = selectedCategory?.bgColor {
//
//            guard let navBar = navigationController?.navigationBar else {
//                fatalError("navigation controller does not exist")
//            }
//            navigationController?.navigationBar.barTintColor =  UIColor(hexString: barTint)
//
//        }
        
    }
    
    // otherwise it wont run.
    override func viewWillAppear(_ animated: Bool) {

    if let barTint = selectedCategory?.bgColor {
        title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {
                   fatalError("navigation controller does not exist")
               }
        if let navBarColour = UIColor(hexString: barTint) {
            navBar.backgroundColor =  UIColor(hexString: barTint)
//            searchBar.barTintColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
            searchBar.barTintColor = ContrastColorOf(navBarColour, returnFlat: true)
            if let bartintcolor =  searchBar.barTintColor {
            searchBar.searchTextField.textColor = ContrastColorOf(bartintcolor, returnFlat: true)
            }
        }

           }
//        tableView.insetsContentViewsToSafeArea = false
    }
    
    
    //MARK: - Tableview Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (toDoItems?.count)! + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
//        if indexPath.row < (toDoItems?.count)! {
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // the ? before darken ios optional chaining. means that if it's nil it wont go thourgh with it 
            if let finalColor = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage: CGFloat(Double(indexPath.row)/Double(toDoItems!.count))) {
                 cell.backgroundColor = finalColor
                cell.textLabel?.textColor = ContrastColorOf(finalColor, returnFlat: true)
            }
            cell.accessoryType = (item.done == true) ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items yet"
            cell.accessoryType = .none
        }
//        } else {
//             cell.textLabel?.text = "No items yet"
//        }
        return cell
        
    }
    
    
    
    //MARK: - tv delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    //                realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status")
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var tf = UITextField()
        let alert = UIAlertController(title: "Add To Do", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = tf.text!
//                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    
                }
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print("item alert closed")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New item"
            tf = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func load() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    // delete
    override func delete(at indexPath: IndexPath) {
        if let selectedItem = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(selectedItem)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }  else {
            print("nothing selected error")
        }
    }
}


//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
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
