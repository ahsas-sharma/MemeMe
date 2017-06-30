//
//  MemeSettingsTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 26/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class MemeSettingsTableViewController: UITableViewController {


    
    @IBOutlet weak var settingsFontTypeCell: UITableViewCell!
    @IBOutlet weak var settingsFontSizeCell: UITableViewCell!
    @IBOutlet weak var settingsFontColorCell: UITableViewCell!
    @IBOutlet weak var settingsBorderWidthCell: UITableViewCell!
    @IBOutlet weak var settingsBorderColorCell: UITableViewCell!
    
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var borderWidthStepper: UIStepper!
    @IBOutlet weak var textPreviewLabel: UILabel!
    @IBOutlet weak var textFieldsLockSwitch: UISwitch!
    @IBOutlet weak var fontColorView: UIView!
    @IBOutlet weak var borderColorView: UIView!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var borderWidthLabel: UILabel!
    
    var textAttributes: TextAttributes!
    
    var selectedFontIndexPath: IndexPath!
    var memeEditorVC: MemeEditorViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in [fontColorView, borderColorView] {
            view?.layer.cornerRadius = 5.0
            view?.layer.borderWidth = 1.0
            view?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCellLabelsAndViews(with: textAttributes)
        print("textAttributes: fontColor: \(String(describing: textAttributes.fontColor.cgColor.components))")
        print("fontColorView: fontColor: \(String(describing: fontColorView.backgroundColor?.cgColor.components))")

        updatePreviewTextLabel()

        self.textFieldsLockSwitch.isOn = memeEditorVC.isTextFieldPositionLocked
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        memeEditorVC.textAttributes = self.textAttributes
        memeEditorVC.isTextFieldPositionLocked = self.textFieldsLockSwitch.isOn
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "SelectFontTableViewController":
            let selectFontTableVC = segue.destination as! SelectFontTableViewController
            selectFontTableVC.memeSettingsTableVC = self
            selectFontTableVC.selectedFont = self.textAttributes.fontName
            if textAttributes.fontName == "Impact" {
                selectedFontIndexPath = IndexPath(row: 0, section: 0)
            }
            selectFontTableVC.lastSelectionIndexPath = selectedFontIndexPath
        case "SelectBorderColorTableViewController":
            let selectBorderColorTableVC = segue.destination as! SelectColorTableViewController
            selectBorderColorTableVC.memeSettingsTableVC = self
            selectBorderColorTableVC.selectedBorderColor = self.textAttributes.borderColor
            selectBorderColorTableVC.settingColorFor = .border
        case "SelectFontColorTableViewController":
            let selectFontColorTableViewController = segue.destination as! SelectColorTableViewController
            selectFontColorTableViewController.memeSettingsTableVC = self
            selectFontColorTableViewController.selectedFontColor = self.textAttributes.fontColor
            selectFontColorTableViewController.settingColorFor = .font
        default: ()
        }
    }
 
    
    // MARK: - Actions
    
    @IBAction func resetTextSettings(_ sender: Any) {
        textPreviewLabel.attributedText =  NSAttributedString(string: Constants.previewText, attributes: Constants.defaultTextAttributes.dictionary())
        textAttributes = Constants.defaultTextAttributes
        updateCellLabelsAndViews(with: textAttributes)

    }
    
    @IBAction func fontSizeChanged(_ sender: Any) {
        fontSizeLabel.text = String(Int(fontSizeStepper.value))
        textAttributes.fontSize = CGFloat(fontSizeStepper.value)
        updatePreviewTextLabel()
    }
    
    @IBAction func borderWidthChanged(_ sender: Any) {
        borderWidthLabel.text = String(Int(borderWidthStepper.value))
        textAttributes.borderWidth = Int(borderWidthStepper.value) * -1
        updatePreviewTextLabel()
    }
    
    // MARK: - Helper
    
    func updatePreviewTextLabel() {
         textPreviewLabel.attributedText = NSAttributedString(string: Constants.previewText, attributes: textAttributes.dictionary())
    }
    
    func updateCellLabelsAndViews(with attributes: TextAttributes) {
        settingsFontTypeCell.detailTextLabel?.text = attributes.fontName
        fontSizeLabel.text = String(describing: Int(attributes.fontSize))
        fontColorView.backgroundColor = attributes.fontColor
        borderWidthLabel.text = String(describing: abs(attributes.borderWidth))
        borderColorView.backgroundColor = attributes.borderColor
    }
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell == settingsFontColorCell {
            print("WillDisplay SettingsFontColorCell")
            fontColorView.backgroundColor = self.textAttributes.fontColor
            cell.layoutSubviews()
        }
        if cell == settingsBorderColorCell {
            print("WillDisplay SettingsBorderColorCell")
            borderColorView.backgroundColor = self.textAttributes.borderColor
        }
    }

}
