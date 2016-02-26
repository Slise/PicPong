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


    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureScreen() {
        UIGraphicsBeginImageContext(drawingView.frame.size)
        drawingView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let newEditedImage = UIImageJPEGRepresentation(editedImage, 0.50) {
            let imageFile = PFFile(name: "pong.png", data: newEditedImage)
            let pong = PFObject(className: "Photo")
            pong["pongImage"] = imageFile
            pong.saveInBackground()
        }
        //drawViewHierarchyInRect will draw the view with both bezier and picture
        //       view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates:true)
        //        var editedImage = UIImage()
        //        editedImage = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
    }
    
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
         drawingView.clear()
    }
    
    @IBAction func sendPongPressed(sender: AnyObject) {
        captureScreen()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
