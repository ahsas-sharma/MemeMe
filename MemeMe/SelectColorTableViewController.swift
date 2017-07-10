//
//  SelectColorTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 25/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SelectColorTableViewController: UITableViewController {
    
    // MARK: - Properties
    
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
        switch settingColorFor! {
        case .border:
            self.title = "Set Border Color"
        case .font:
            self.title = "Set Font Color"
        }
        
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
    
    // MARK: - Table view DataSource and Delegate
    
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
                cell.checkmarkImageView.isHidden = false
                lastBorderColorSelectionIndexPath = indexPath
            } else {
                cell.checkmarkImageView.isHidden = true
            }
        case .font:
            if cell.color == selectedFontColor {
                cell.checkmarkImageView.isHidden = false
                lastFontColorSelectionIndexPath = indexPath
            } else {
                cell.checkmarkImageView.isHidden = true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectioncell = tableView.cellForRow(at: indexPath) as! SelectColorTableViewCell
        
        switch settingColorFor! {
        case .border:
            if let lastBorderColorSelectionIndexPath = lastBorderColorSelectionIndexPath {
                
                if indexPath == lastBorderColorSelectionIndexPath {
                    return
                } else {
                    tableView.deselectRow(at: lastBorderColorSelectionIndexPath, animated: true)
                    if let lastSelectedCell = tableView.cellForRow(at: lastBorderColorSelectionIndexPath) as? SelectColorTableViewCell {
                        lastSelectedCell.checkmarkImageView.isHidden = true
                    }
                }
            }
            newSelectioncell.checkmarkImageView.isHidden = false
            selectedBorderColor = newSelectioncell.color
            lastBorderColorSelectionIndexPath = indexPath
            
        case .font:
            if let lastFontColorSelectionIndexPath = lastFontColorSelectionIndexPath {
                
                if indexPath == lastFontColorSelectionIndexPath {
                    return
                } else {
                    tableView.deselectRow(at: lastFontColorSelectionIndexPath, animated: true)
                    
                    if let lastSelectedCell = tableView.cellForRow(at: lastFontColorSelectionIndexPath) as? SelectColorTableViewCell {
                        lastSelectedCell.checkmarkImageView.isHidden = true
                    }
                }
            }
            
            newSelectioncell.checkmarkImageView.isHidden = false
            selectedFontColor = newSelectioncell.color
            lastFontColorSelectionIndexPath = indexPath
        }
        
    }
    
}
