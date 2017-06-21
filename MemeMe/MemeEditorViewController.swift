//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 13/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    // MARK:- Outlets -
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var navbarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: - Properties -
    
    var didSelectImage: Bool = false
    var memedImage: UIImage?
    var showStatusBar: Bool = true
    
    // MARK:- View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.contentMode = .scaleAspectFit
        
        // Enable or disable camera button based on source availability
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Disable share and cancel button when the view first loads
        updateButtonsUI(didSelectImage)
        
        // Define attributes for textfields
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
            NSStrokeWidthAttributeName: -5.0]

        // Set textfields delegate and appearance
        for textfield in textFields {
            textfield.delegate = self
            textfield.defaultTextAttributes = memeTextAttributes
            textfield.textAlignment = .center
        }
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to be notified when keyboard appears and move the view as necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        self.unsubscribeToKeyboardNotifications()
    }

    // Adjusts the navigation bar height based on the orientation (as status bar is hidden in landscape mode on phone)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone {
            self.navbarHeightConstraint.constant = 44
        } else {
            self.navbarHeightConstraint.constant = 64
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return showStatusBar
    }
    
    // MARK:- Actions -
    
    // Allows the user to pick an image from the Photos library
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .overCurrentContext
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Allows the user to take a new picture using the device camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .overCurrentContext
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Opens the acivity view controller
    @IBAction func shareImage(_ sender: UIButton) {
        
        // Generate and store the meme image
        self.memedImage = self.generateMemedImage()
        
        // Setup the activity view controller
        let imageToShare = [ memedImage! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        // Fix for crashes on iPad
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.completionWithItemsHandler =
            { (activityType, completed, returnedItems, error) in
               
                if error != nil {
                    // Just debug print for now. Can better handle error through an alert with retry action.
                    debugPrint("There was an error!")
                } else {
                    
                    // Create a Meme object
                    self.saveMeme()
                    
                    // If user selects 'Save Image' and the task completes, display a success message
                    if activityType == UIActivityType.saveToCameraRoll && completed {
                        
                        // Display a message to inform the user of save success
                        let alertController = UIAlertController(title: "", message: "Meme saved to Photos library!", preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        
                        // Dissmiss the alert after 2 seconds
                        let dismissTime = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: dismissTime){
                            alertController.dismiss(animated: true, completion: nil)
                        }

                    }
                }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // Resets the Meme editor to its default state
    @IBAction func resetMemeEditor() {
            self.imageView.image = nil
            self.topTextField.text = "TOP"
            self.bottomTextField.text = "BOTTOM"
    }
    
    // MARK:- Keyboard -
    
    // Move up the main view by the height of the keyboard
    func keyboardWillShow(_ notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        resetViewFrame()
    }
    
    // Return the height of keyboard's frame using the notification
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Subscribe to get notified when the keyboard is about to appear
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Unsubscribe from UIKeyboardWillShow notification
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK:- Helper functions
    
    // Reset the view frame's y axis back to the original state
    func resetViewFrame() {
        view.frame.origin.y = 0
    }
    
    // Update share and cancel buttons based on image selection
    func updateButtonsUI(_ isEnabled: Bool) {
        self.shareButton.isEnabled = isEnabled
        self.cancelButton.isEnabled = isEnabled
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationBar.isHidden = true
        self.toolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationBar.isHidden = false
        self.toolbar.isHidden = false
        
        return memedImage
    }
    
    func saveMeme() {
        
        // Create an instance of Meme (named changed to silence compiler warning for an unused value)
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memeImage: memedImage!)
    }
    
}

// MARK:- ImagePicker Delegate -

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.didSelectImage = true
            updateButtonsUI(didSelectImage)
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK:- TextField Delegate -

extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !didSelectImage {
            let alertController = UIAlertController(title: "No image selected", message: "To begin editing, please select an image from the library or using the camera.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return didSelectImage
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.bottomTextField {
            self.showStatusBar = false
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.bottomTextField {
            self.showStatusBar = true
            setNeedsStatusBarAppearanceUpdate()
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
