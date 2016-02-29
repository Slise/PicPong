//
//  EditPongView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EditPongViewController: UIViewController {

    var image = UIImage()
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var pongImageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pongImageView.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func savePong() {
        
        UIGraphicsBeginImageContext(parentView.frame.size)
        parentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let user = Player.currentUser(),
            let pongImage = editedImage else { return }
        let newImage = Photo()
        newImage.player = user
        
        var pictureData = UIImagePNGRepresentation(pongImage)!
        
        while pictureData.length > 5000000 {
            pictureData = UIImageJPEGRepresentation(pongImage, 0.5)!
        }
        
        if let newEditedimage = PFFile(data: pictureData) {
            newImage.pongImage = newEditedimage
            newEditedimage.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    print("success")
                }
            })
        }
        
        newImage.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                print("pong saved")
                let pong = Pong()
                pong.photos.append(newImage)
                pong.originalPlayer = Player.currentUser()!
                pong.nextPlayer = nil
                pong.saveInBackgroundWithBlock {(success, error) -> Void in
                    if success {
                        print("added image to pong array")
                    } else {
                        print("error")
                    }
                }
            } else {
                print("Error: \(error)")
            }
        })
//        if let newEditedImage = UIImageJPEGRepresentation(editedImage, 0.50),
//            let imageFile = PFFile(data:newEditedImage){
//                let pong = Photo()
//                pong.pongImage = imageFile
//                imageFile.saveInBackgroundWithBlock({ (success, error) -> Void in
//                    if success {
//                        print("success saving file")
//                    }
//                })
//                pong.saveInBackgroundWithBlock({ (success, error)  in
//                    if success{
//                        print("success saving photo")
//                        
//                    }
//                })
//        }
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
         drawingView.clear()
    }
    
    @IBAction func sendPongPressed(sender: AnyObject) {
        savePong()
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
