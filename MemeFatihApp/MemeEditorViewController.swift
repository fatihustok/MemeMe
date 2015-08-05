//
//  MemeEditorViewController.swift
//  MemeFatihApp
//
//  Created by Refik Fatih Ustok on 5/08/15.
//  Copyright (c) 2015 Refik Fatih Ustok. All rights reserved.
//
import UIKit

class MemeEditorViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    var cameraButton = UIBarButtonItem()
    var flexiblespace = UIBarButtonItem()
    var albumButton = UIBarButtonItem()
    
    var shareButton = UIBarButtonItem()
    var cancelButton = UIBarButtonItem()
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    //MARK:- Meme data
    
    var memedImage = UIImage()
    var meme:Meme!
    var memes = [Meme]()
    
    var keyboardHidden = true //View starts with the keyboard hidden
    
    
    // Meme Text Atributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumButton = UIBarButtonItem(title: "Album", style: .Done, target: self, action: "pickAnImageFromAlbum:")
        cameraButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "pickAnImageFromCamera:")
        flexiblespace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        
        shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "share")
        cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        flexiblespace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        
        
        
        
        var fixedWidth = self.view.frame.size.width;
        var fixedHeight = self.view.frame.size.height;
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.toolbarHidden = false
        self.navigationController?.view.backgroundColor = UIColor.whiteColor() //When zooming the background should be white.
        bottomTextField.sizeToFit()
        topTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.backgroundColor = UIColor.clearColor()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
        
        // If Camera is not available
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            cameraButton.enabled = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.toolbarItems = [flexiblespace,cameraButton,flexiblespace,albumButton,flexiblespace]
        self.navigationItem.leftBarButtonItem = shareButton
        self.navigationItem.rightBarButtonItem = cancelButton
        self.navigationController?.toolbarHidden = false

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
            shareButton.enabled = true
        }
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Dismiss the Image Picker on Cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //After the enter is pressed at we dismiss the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.isEqual(bottomTextField){
            self.unsubscribeFromKeyboardNotifications()
        }
        return true
    }
    
    //At the begining of Editing if the default text is written We reset it
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
        if textField.isEqual(bottomTextField){
            self.subscribeToKeyboardNotifications()
        }
    }
    
    //MARK:- KEYBOARD RELATED
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(keyboardHidden ){ //If the keyboard was not hidden.(e.g. we change the type of the keyboard on currently displayed keyboard view) there's no need to change the origin.
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardHidden = false
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(!keyboardHidden){//If the keyboard was hidden.(e.g. we change the type of the keyboard on currently displayed keyboard view) there's no need to change the origin.
            self.view.frame.origin.y += getKeyboardHeight(notification)
            keyboardHidden = true
        }
    }
    
    
    func generateMemedImage() -> UIImage
    {
        // Render view to an image
        //Hide toolbar and navbar
        hide(true,animated: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //Hide toolbar and navbar
        hide(false,animated: false)
        
        return memedImage
        
    }
    
    //Function to save the Meme.It is used only by the share method. It saves the Meme to appdelegate
    func save() {
        //Create the meme
        memedImage = generateMemedImage()
        var meme = Meme(topText:topTextField.text!, bottomText: bottomTextField.text!,  image: imagePickerView.image!,  memedImage: memedImage)
        self.meme = meme
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    
    func share() {
        save()
        let objectsToShare = [UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeSaveToCameraRoll]
        
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activity.completionWithItemsHandler = { (activity, success, items, error) in
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeTabBarController")! as! UITabBarController
            
            self.navigationController!.presentViewController(detailController, animated: true, completion: nil)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: false) //Set the toolbar hidden so as to enable the table view's toolbar.
            
        }
        
        self.presentViewController(activity, animated: true, completion:nil)
        
    }
    
    
    func cancel() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)//Dismiss the First-root controller.
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeTabBarController")! as! UITabBarController
        self.navigationController?.presentViewController(detailController, animated: true,completion:nil)
        
    }
    
    func hide(flag:Bool,animated:Bool){
        self.navigationController?.setNavigationBarHidden(flag, animated: animated)
        self.navigationController?.setToolbarHidden(flag, animated: animated)
    }
    
    
    
}
