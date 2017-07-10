//
//  SelectFontTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 26/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SelectFontTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var selectedFont: String!
    var lastSelectionIndexPath: IndexPath!
    var memeSettingsTableVC: MemeSettingsTableViewController!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        memeSettingsTableVC.textAttributes.fontName = selectedFont
        memeSettingsTableVC.selectedFontIndexPath = lastSelectionIndexPath
    }
    
    // MARK: - Table View DataSource and Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.fonts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFontTableViewCell", for: indexPath) as! SelectFontTableViewCell
        
        let fontName = Constants.fonts[indexPath.row]
        cell.fontName = fontName
        cell.textLabel?.font = UIFont(name: fontName, size: 17)!
        cell.textLabel?.text = fontName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! SelectFontTableViewCell
        if cell.fontName == selectedFont {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected indexPath :\(indexPath)")
        
        // Deselect the previous selection
        if let lastSelectionIndexPath = lastSelectionIndexPath {
            tableView.deselectRow(at: lastSelectionIndexPath, animated: true)
            
            if let lastSelectedCell = tableView.cellForRow(at: lastSelectionIndexPath) {
                if lastSelectedCell.accessoryType == .checkmark {
                    lastSelectedCell.accessoryType = .none
                }
            }
            print("LastSelectedIndexPath: \(lastSelectionIndexPath)")
            
            if indexPath == lastSelectionIndexPath {
                return
            }
        }
        
        // Mark the new cell selection with a checkmark
        let newSelectionCell = tableView.cellForRow(at: indexPath) as! SelectFontTableViewCell
        if newSelectionCell.accessoryType == .none {
            newSelectionCell.accessoryType = .checkmark
        }
        lastSelectionIndexPath = indexPath
        selectedFont = newSelectionCell.fontName
    }
    
    
}
