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
        // Dispose of any resources that can be recreated.
    }
    
    func captureScreen() {
        UIGraphicsBeginImageContext(parentView.frame.size)
        parentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let newEditedImage = UIImageJPEGRepresentation(editedImage, 0.50),
            let imageFile = PFFile(data:newEditedImage){
                let pong = Photo()
                pong.pongImage = imageFile
                imageFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        print("success saving file")
                    }
                })
                pong.saveInBackgroundWithBlock({ (success, error)  in
                    if success{
                        print("success saving photo")
                        
                        //send notification
                    }
                })
        }
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
         drawingView.clear()
    }
    
    @IBAction func sendPongPressed(sender: AnyObject) {
        captureScreen()
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
