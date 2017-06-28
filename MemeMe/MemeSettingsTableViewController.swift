//
//  MemeSettingsTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 26/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class MemeSettingsTableViewController: UITableViewController {

    @IBOutlet weak var textPreviewLabel: UILabel!
    
    var customTextAttributes: TextAttributes?
    var memeEditorVC: MemeEditorViewController!
    @IBOutlet weak var textFieldsLockSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if customTextAttributes != nil {
            textPreviewLabel.attributedText = NSAttributedString(string: Constants.previewText, attributes: customTextAttributes?.attributesDict())
        } else {
            textPreviewLabel.attributedText =  NSAttributedString(string: Constants.previewText, attributes: Constants.defaultTextAttributes.attributesDict())
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear()")
        print("isTextFieldLocked? \(textFieldsLockSwitch.isOn)")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTextPreviewCell", for: indexPath)
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsFontTypeCell", for: indexPath)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsFontSizeCell", for: indexPath)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsFontColorCell", for: indexPath)
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsBorderWidthCell", for: indexPath)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsBorderColorCell", for: indexPath)
                return cell
            default:
                return UITableViewCell()
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLockTextFieldCell", for: indexPath)
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func resetTextSettings(_ sender: Any) {
        textPreviewLabel.attributedText =  NSAttributedString(string: Constants.previewText, attributes: Constants.defaultTextAttributes.attributesDict())

    }

}
