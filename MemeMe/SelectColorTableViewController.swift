//
//  SelectColorTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 25/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SelectColorTableViewController: UITableViewController {

    enum SetColorFor {
        case border, font
    }
    
    var colors = [UIColor]()
    var memeSettingsTableVC: MemeSettingsTableViewController!
    
    var selectedBorderColor: UIColor!
    var selectedFontColor: UIColor!

    var settingColorFor: SetColorFor!
    var lastBorderColorSelectionIndexPath: IndexPath!
    var lastFontColorSelectionIndexPath: IndexPath!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colors = Constants.Colors.array()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Setting Color for :\(settingColorFor)")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch settingColorFor! {
        case .border:
            memeSettingsTableVC.textAttributes.borderColor = selectedBorderColor
        case .font:
            memeSettingsTableVC.textAttributes.fontColor = selectedFontColor
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectColorTableViewCell", for: indexPath) as! SelectColorTableViewCell
        cell.backgroundColor = colors[indexPath.row]
        cell.color = colors[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! SelectColorTableViewCell
        switch settingColorFor! {
        case .border:
           if cell.color == selectedBorderColor {
                toggleCellUIOnSelect(cell: cell, select: true)
                lastBorderColorSelectionIndexPath = indexPath
            } else {
                toggleCellUIOnSelect(cell: cell, select: false)
            }
        case .font:
            if cell.color == selectedFontColor {
                toggleCellUIOnSelect(cell: cell, select: true)
                lastFontColorSelectionIndexPath = indexPath
            } else {
                toggleCellUIOnSelect(cell: cell, select: false)
            }
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectioncell = tableView.cellForRow(at: indexPath) as! SelectColorTableViewCell
        
        switch settingColorFor! {
        case .border:
            if let lastBorderColorSelectionIndexPath = lastBorderColorSelectionIndexPath {
                tableView.deselectRow(at: lastBorderColorSelectionIndexPath, animated: true)

                if let lastSelectedCell = tableView.cellForRow(at: lastBorderColorSelectionIndexPath) {
                    self.toggleCellUIOnSelect(cell: lastSelectedCell, select: false)
                }
                
                if indexPath == lastBorderColorSelectionIndexPath {
                    return
                }
            }
            self.toggleCellUIOnSelect(cell: newSelectioncell, select: true)
            selectedBorderColor = newSelectioncell.color
            lastBorderColorSelectionIndexPath = indexPath
            
        case .font:
            if let lastFontColorSelectionIndexPath = lastFontColorSelectionIndexPath {
                tableView.deselectRow(at: lastFontColorSelectionIndexPath, animated: true)
                
                if let lastSelectedCell = tableView.cellForRow(at: lastFontColorSelectionIndexPath) {
                    self.toggleCellUIOnSelect(cell: lastSelectedCell, select: false)
                }
                
                if indexPath == lastFontColorSelectionIndexPath {
                    return
                }
            }
            self.toggleCellUIOnSelect(cell: newSelectioncell, select: true)
            selectedFontColor = newSelectioncell.color
            lastFontColorSelectionIndexPath = indexPath
        }
        
    }
//    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        toggleCellUIOnSelect(cell: cell!, select: false)
//    }
    
    // MARK: - Helper
    
    func toggleCellUIOnSelect(cell: UITableViewCell, select: Bool) {
        if select {
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 5.0
            cell.layer.cornerRadius = 20.0
        } else {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0.0
            cell.layer.cornerRadius = 0.0

        }
    }


}
