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
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: - Properties -
    
    var didSelectImage: Bool = false
    var memedImage: UIImage?
    var memeToEdit: Meme!
    
    var topGestureRecognizer: UIPanGestureRecognizer!
    var bottomGestureRecognizer: UIPanGestureRecognizer!
    
    var customTopTextFieldCenter: CGPoint?
    var customBottomTextFieldCenter: CGPoint?
    var isTextFieldPositionLocked: Bool = true
    
    var textAttributes: TextAttributes = Constants.defaultTextAttributes
    
    var viewFrameOriginY: CGFloat!
    
    // MARK:- View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.contentMode = .scaleAspectFit
        
        // Disable share and cancel button when the view first loads
        updateButtonsUI(didSelectImage)
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        // Add pan gesture recognizers to allow user to reposition the text fields
        topGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MemeEditorViewController.userDraggedTextField(gesture:)))
        bottomGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MemeEditorViewController.userDraggedTextField(gesture:)))
        topTextField.addGestureRecognizer(topGestureRecognizer)
        bottomTextField.addGestureRecognizer(bottomGestureRecognizer)
        
        // Store default position
        Constants.defaultTopTextFieldCenter = topTextField.center
        Constants.defaultBottomTextFieldCenter = bottomTextField.center
        
        // If MemeEditor is opened to edit a meme, load it up
        if memeToEdit != nil {
            loadSavedMemeInEditor(memeToEdit)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Enable or disable camera button based on source availability
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Subscribe to be notified when keyboard appears and move the view as necessary
        self.subscribeToKeyboardNotifications()
        
        // Apply text attributes
        // Set textfields delegate and appearance
        for textfield in textFields {
            textfield.delegate = self
            textfield.defaultTextAttributes = textAttributes.dictionary()
            textfield.textAlignment = .center
        }
        
        // If a meme image was selected or if editing an existing meme, update buttons UI
        updateButtonsUI(didSelectImage)
        
    }
    
    // Apply custom text field positions
    override func viewDidLayoutSubviews() {
        self.textAttributes.topTextFieldCenter != nil ? self.topTextField.center =  self.textAttributes.topTextFieldCenter! : ()
        self.textAttributes.bottomTextFieldCenter != nil ? self.bottomTextField.center = self.textAttributes.bottomTextFieldCenter! : ()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        self.unsubscribeToKeyboardNotifications()
    }
    
    
    // Adjusts the navigation bar height based on the orientation (as status bar is hidden in landscape mode on phone)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.navigationController?.navigationBar.frame.size.height = 44
        } else {
            self.navigationController?.navigationBar.frame.size.height = 64
        }
    }
    
    
    // MARK:- Actions -
    
    // Allows the user to pick an image from the Photos library
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImageFrom(.photoLibrary)
    }
    
    // Allows the user to take a new picture using the device camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageFrom(.camera)
    }
    
    // Allows the user to pick an image from a collection of popular meme images
    @IBAction func pickAnImageFromTemplates(_ sender: Any) {
        let memeTemplatesNavigationController = self.storyboard!.instantiateViewController(withIdentifier: "MemeTemplatesNavigationController") as! UINavigationController
        let templatesVC = memeTemplatesNavigationController.viewControllers.first as! MemeTemplatesCollectionViewController
        templatesVC.memeEditorVC = self
        present(memeTemplatesNavigationController, animated: true, completion: nil)
    }
    
    // Opens the acivity view controller to share the image
    @IBAction func shareImage(_ sender: UIButton) {
        
        ControllerUtils.presentShareActivityControllerWithOptions(memeImage: generateMemedImage(), presentor: self, sourceView: self.view, createNew: true, saveHandler: saveMeme)
    }
    
    /// Reset the editor and all properties to their default state
    @IBAction func resetMemeEditor() {
        
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.center = Constants.defaultTopTextFieldCenter
        bottomTextField.center = Constants.defaultBottomTextFieldCenter
        textAttributes = Constants.defaultTextAttributes
        
        didSelectImage = false
        updateButtonsUI(didSelectImage)
    }
    
    /// Dismiss the presented instance of MemeEditorViewController
    @IBAction func dismissMemeEditor() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Keyboard -
    
    /// Move up the main view by the height of the keyboard
    func keyboardWillShow(_ notification: NSNotification) {
        viewFrameOriginY = view.frame.origin.y
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1) + 64
        }
    }
    
    /// Return frame to its original position
    func keyboardWillHide(_ notification: NSNotification) {
        if let viewFrameOriginY = viewFrameOriginY {
            view.frame.origin.y = viewFrameOriginY
        }
    }
    
    /// Return the height of keyboard's frame using the notification
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    /// Subscribe to get notified when the keyboard is about to show or hide
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    /// Unsubscribe from keyboard notification
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK:- Helper functions -
    
    /// Update share and cancel buttons based on image selection
    func updateButtonsUI(_ isEnabled: Bool) {
        self.shareButton.isEnabled = isEnabled
        self.resetButton.isEnabled = isEnabled
    }
    
    /// Presents an imagePickerController based on the source type
    func pickAnImageFrom(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        imagePicker.setEditing(true, animated: true)
        imagePicker.modalPresentationStyle = .overCurrentContext
        
        imagePicker.navigationBar.isTranslucent = true
        imagePicker.navigationBar.barStyle = .black
        imagePicker.navigationBar.tintColor = .white
        imagePicker.navigationBar.barTintColor = .black
        imagePicker.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white]
        imagePicker.view.backgroundColor = Constants.Colors.blackLight
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Returns a UIImage object generated from the current view
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.toolbar.isHidden = true
        self.view.layoutIfNeeded()
        
        // A somewhat crude approach to fix text placement issue when capturing view hierarchy with custom positioned textFields (probably status bar height related issue)
        for textField in textFields {
            if (textField == topTextField && textField.center != Constants.defaultTopTextFieldCenter) || (textField == bottomTextField && textField.center != Constants.defaultBottomTextFieldCenter){
                textField.frame.origin.y -= 20
            }
        }
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Reset textfields positions after view has been captured
        for textField in textFields {
            textField.frame.origin.y += 20
        }
        
        // Show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.toolbar.isHidden = false
        self.view.layoutIfNeeded()
        
        return memedImage
    }
    
    /// Create an instance of Meme and append it to the memes array in AppDelegate
    func saveMeme() {
        Meme.saveMeme(topTextField: topTextField, bottomTextField: bottomTextField, originalImage: imageView.image!, memeImage: generateMemedImage(), textAttributes: textAttributes)
    }
    
    /// Prepares the editor by seting the textfields and imageView values as per the saved Meme object
    ///
    /// - Parameter meme: Meme object to edit
    func loadSavedMemeInEditor(_ meme: Meme) {
        self.topTextField.text = meme.topText
        self.bottomTextField.text = meme.bottomText
        self.imageView.image = meme.originalImage
        self.textAttributes = meme.textAttributes
        
        // Set text attributes and custom text field center values (if available)
        for textField in self.textFields {
            textField.defaultTextAttributes = meme.textAttributes.dictionary()
        }
        
        self.didSelectImage = true
    }
    
    /// Repositions the text field based on pan gesture (if position is unlocked)
    func userDraggedTextField(gesture: UIPanGestureRecognizer){
        if !isTextFieldPositionLocked {
            let loc = gesture.location(in: self.view)
            if gesture == topGestureRecognizer {
                self.topTextField.center = loc
                self.customTopTextFieldCenter = loc
                self.textAttributes.topTextFieldCenter = loc
            } else {
                self.bottomTextField.center = loc
                self.customBottomTextFieldCenter = loc
                self.textAttributes.bottomTextFieldCenter = loc
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemeSettingsTableViewController" {
            let memeSettingsVC = segue.destination as! MemeSettingsTableViewController
            
            // Retain reference to the instance of meme editor view controller
            memeSettingsVC.memeEditorVC = self
            memeSettingsVC.textAttributes = self.textAttributes
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

// MARK:- ImagePicker Delegate -

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // On iPads, there is an issue with the image selection when editing is enabled. Either the wrong image is picked or it is not cropped properly. Unable to figure out a solution. Found a bug filing on openradar-mirror at https://github.com/lionheart/openradar-mirror/issues/5198
        let image = (info[UIImagePickerControllerEditedImage] as? UIImage) != nil ? (info[UIImagePickerControllerEditedImage] as? UIImage) : (info[UIImagePickerControllerOriginalImage] as? UIImage)
        
        imageView.image = image
        didSelectImage = true
        updateButtonsUI(didSelectImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK:- TextField Delegate -

extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // If no image has been selected, alert the user and return false else clear the default text and begin editing
        if !didSelectImage {
            let alertController = UIAlertController(title: "No image selected", message: "To begin editing, please select an image.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            if textField == topTextField && textField.text == "TOP" {
                topTextField.text = ""
            }
            if textField == bottomTextField && textField.text == "BOTTOM" {
                bottomTextField.text = ""
            }
        }
        return didSelectImage
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // If text field returns with empty string, reset to default text
        if textField.text == "" {
            textField == topTextField ? (textField.text = "TOP") : (textField.text = "BOTTOM")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
