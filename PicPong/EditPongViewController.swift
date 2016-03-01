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
    
    // MARK: - Variables -
    
    var pong: Pong?
    var image: UIImage?
    
    // MARK: - Outlets -
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var pongImageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayImage()
    }
    
    // MARK: General Methods
    
    func displayImage() {
        if pong == nil {
            self.pongImageView.image = image
        } else {
            let imageFile = pong!.photos.last!.pongImage
            imageFile.getDataInBackgroundWithBlock { data, error in
                let image = UIImage(data:data!)
                self.pongImageView.image = image
            }
        }
    }
    
    func savePong() {
        guard let user = Player.currentUser() else { return }
        guard let parseImage = PFFile(data: getEditedImageData()) else { return }
        let parsePhoto = Photo(image: parseImage, player: user)
        
        parseImage.saveInBackgroundWithBlock { success, error in
            if self.pong == nil {
                self.pong = Pong()
                self.pong!.photos = [parsePhoto]
                self.pong!.originalPlayer = user
                self.pong!.nextPlayer = nil
            } else {
                self.pong!.photos.append(parsePhoto)
                self.pong!.nextPlayer = self.pong!.photos.count > 7 ? self.pong!.originalPlayer : nil
            }
            self.pong!.saveInBackgroundWithBlock { success, error in
                print("saved pong")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func getEditedImageData() -> NSData {
        return getImageData(getEditedImage())
    }
    
    func getImageData(image: UIImage) -> NSData {
        var data = UIImagePNGRepresentation(image)!
        while data.length > 5000000 {
            data = UIImageJPEGRepresentation(image, 0.5)!
        }
        return data
    }
    
    func getEditedImage() -> UIImage {
        UIGraphicsBeginImageContext(parentView.frame.size)
        parentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return editedImage
    }
    
    // MARK: - Actions -
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
         drawingView.clear()
    }
    
    @IBAction func sendPongPressed(sender: AnyObject) {
        savePong()
    }
}
