//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Laura Ghiorghisor on 19/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

/* this class is A SUPER class from which the other two conrollers will inherit,
 in order to get the swip cell fucntionality.
 */
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // Table view data source methods that will be overwritten in the children
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
//                cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
                cell.delegate = self
                return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("item deleted")
            self.delete(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //            options.transitionStyle = .border
        return options
    }
    
    func delete(at indexPath: IndexPath) {
        // update our data model
        // will be overwritten in the child
    }
}

