//
//  MemeMeViewController.swift
//  MemeMePart1
//
//  Created by Jawaune on 5/15/18.
//  Copyright © 2018 jaelong. All rights reserved.
//
//Refer to link below to see what it should look like
//https://docs.google.com/document/d/1G2onkzN_weWmiYErhQJw1lB9-zxM-2TQ0N5bNMAaI7I/pub?embedded=true



import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated:true)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let image = generateMemedImage()
        launchShareActivityFor(image: image)
    }
    
    
    //Present the Camera
    @IBAction func tappedOnCamera(_ sender: Any) {
        setupUIPicker(sourceType: .camera)
    }
    
    //Tapped On Album Icon
    @IBAction func tappedOnPicker(_ sender: Any) {
        setupUIPicker(sourceType: .photoLibrary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        
        navigationController?.toolbar.setToHidden()
        //Disable the camera button if the camera is unavilable
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Disable share button if there's no image in imageview
        shareButton.isEnabled = imageView.image != nil
        cancelButton.isEnabled = shareButton.isEnabled
        tabBarController?.tabBar.setToHidden()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Create The Impact Font
        let impactFontStyle: [String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedStringKey.strokeWidth.rawValue : -5]
        
        setupTextFieldFrom(textField: topTextField, with: "TOP", attributes: impactFontStyle)
        setupTextFieldFrom(textField: bottomTextField, with: "BOTTOM", attributes: impactFontStyle)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        tabBarController?.tabBar.setToHidden(false)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Grab the image chosen from the photolibrary out of the dictionary using the info key, and set the image view's image to that chosen image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Display The Impact Font
    func setupTextFieldFrom(textField: UITextField, with displayText: String, attributes: [String: Any], alignment: NSTextAlignment = .center) {
        textField.text = displayText
        textField.defaultTextAttributes = attributes
        
    }
    
    //Listen for when the keyboard is showing and hiding
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    //Stop Listening to keyboard
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    //Will move bottomTextField up if keyboard is about to appear
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            moveViewBy(points: 43.5, from: notification)
        }
        
        if topTextField.isEditing && UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            moveViewBy(points: 87, from: notification)

        }
    }
    
    func moveViewBy(points: CGFloat, from notification: Notification) {
        view.frame.origin.y += points - getKeyboardHeight(notification)
        UIView.animate(withDuration: 0.8, animations: { self.view.layoutIfNeeded()})
    }
    
    
    //Reset View Back when keyboard disappears
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
        UIView.animate(withDuration: 0.8, animations: { self.view.layoutIfNeeded()})
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func generateMemedImage() -> UIImage  {
        navigationBar.setToHidden()
        toolbar.setToHidden()
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        view.snapshotView(afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.setToHidden(false)
        toolbar.setToHidden(false)
        
        return memedImage
    }
    
    
    func launchShareActivityFor(image: UIImage){
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareButton
        activityViewController.completionWithItemsHandler =
            { (activity, success, items, error) in
                if success && error == nil{
                    self.save(memedImage: image)
                    self.dismiss(animated: true, completion: nil)
                }   else if (error != nil){
                    print(error.debugDescription)
                }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    func setupUIPicker(sourceType: UIImagePickerControllerSourceType){
        let uipicker = UIImagePickerController()
        uipicker.delegate = self
        uipicker.sourceType = sourceType
        present(uipicker, animated: true, completion: nil)
    }
    
    func save(memedImage: UIImage){
        // Create a meme object
        guard let topText = topTextField.text, let bottomText = bottomTextField.text, let imagedata = imageView.image?.data else { return }
        let meme = Meme(topText: topText, bottomText:bottomText, imageData: imagedata, memedImageData: (memedImage.data))
        DataModel.persistMeme(meme: meme)
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
