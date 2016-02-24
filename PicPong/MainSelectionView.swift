//
//  MainSelectionView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-22.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class MainSelectionView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    override func viewDidLoad() {
//        let testObject = PFObject(className: "Pong")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Object has been saved.")
            self.imagePicker.delegate = self
        }
    
// MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if let imageData = UIImageJPEGRepresentation(image, 0.50) {
        let imageFile = PFFile(name:"pong.png", data:imageData)
        let userPhoto = PFObject(className:"Pong")
        userPhoto["image"] = imageFile
        userPhoto.saveInBackground()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}