//
//  ViewController.swift
//  MemeMePart1
//
//  Created by Jawaune on 5/15/18.
//  Copyright © 2018 jaelong. All rights reserved.
//

import UIKit


class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        
        
        //Disable the camera button if the camera is unavilable
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Disable share button if there's no image in imageview
        shareButton.isEnabled = imageView.image != nil
        
        if shareButton.isEnabled {
            clearButton.isEnabled = true
        } else {
            clearButton.isEnabled = false
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad(){
         super.viewDidLoad()
        let impactFontStyle: [String:Any] = [     NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
                                                  NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
                                                  NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
                                                  NSAttributedStringKey.strokeWidth.rawValue : -5]
        
        setupTextFieldFrom(textField: topTextField, with: "TOP", attributes: impactFontStyle)
        
        setupTextFieldFrom(textField: bottomTextField, with: "BOTTOM", attributes: impactFontStyle)
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    //the picker button is part of the toolbar
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBAction func didTapClear(_ sender: UIBarButtonItem) {
        resetMemeEditor()
    }
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let image = generateMemedImage()
        launchShareActivityFrom(image: image)
    }
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    //Present the Camera
    @IBAction func tappedOnCamera(_ sender: Any) {
        setupUIPicker(sourceType: .camera)
    }
    
    //Tapped On Albums
    @IBAction func tappedOnPicker(_ sender: Any) {
        //Create the picker
        setupUIPicker(sourceType: .photoLibrary)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Grab the image out of the dictionary using the info key, and set the image view to the image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] else {return}
        imageView.image = image as? UIImage
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //Create The Impact Font
    
    func setupTextFieldFrom(textField: UITextField, with displayText: String, attributes: [String: Any]) {
        textField.text = displayText
        textField.defaultTextAttributes = attributes
        
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
    }
    
    //Will move bottomTextfield up if keyBoard is about to appear
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y  -= getKeyboardHeight(notification)
            UIView.animate(withDuration: 0.8, animations: { self.view.layoutIfNeeded()})
        }
    }
    
    //Reset View Back when keyboard disappears
    @objc func keyboardWillHide(_ notification: Notification){
        
        view.frame.origin.y = 0
        UIView.animate(withDuration: 0.8, animations: { self.view.layoutIfNeeded()})
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func generateMemedImage() -> UIImage  {
        
        //hide navigation bar
        navigationBar.isHidden = true
        //hide the tool bar
        toolbar.isHidden = true
        //https://www.youtube.com/watch?v=6o4PmMywIA8 this link better explains the sharing images and stuff
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        view.snapshotView(afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolbar.isHidden = false
        return memedImage
    }
    func save(){
        // Create the meme
        _ = Meme(topText: topTextField.text, bottomText: bottomTextField.text, orginalImage: imageView.image, memedImage:imageView.image!)
    }
    
    func launchShareActivityFrom(image: UIImage){
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareButton
        activityViewController.completionWithItemsHandler =
            { (activity, success, items, error) in
                if(success && error == nil){
                    self.save()
                    self.dismiss(animated: true, completion: nil);
                }
                else if (error != nil){
                    print(error.debugDescription)
                }
        }
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func resetMemeEditor() {
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        clearButton.isEnabled = false
        shareButton.isEnabled = false
    }
    
    func setupUIPicker(sourceType: UIImagePickerControllerSourceType){
        let uipicker = UIImagePickerController()
        uipicker.delegate = self
        uipicker.sourceType = sourceType
        present(uipicker, animated: true, completion: nil)
    }
}



extension MemeMeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
    }
}