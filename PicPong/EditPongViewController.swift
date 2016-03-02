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

class EditPongViewController: UIViewController, DrawingViewDelegate {
    
    // MARK: - Variables -
    
    var pong: Pong?
    var image: UIImage?
    
    // MARK: - Outlets -
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var pongImageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var pongItButton: UIBarButtonItem!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImage()
        pongItButton.enabled = false
        drawingView.delegate = self
    }
    
    // MARK: General Methods
    
    func imageEdited() {
        pongItButton.enabled = true
    }
    
    func clearEdit() {
        pongItButton.enabled = false
    }
    
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
            
            if let pong = self.pong {
                pong.photos.append(parsePhoto)
                if pong.photos.count > 7 || pong.nextPlayer?.objectId == pong.originalPlayer.objectId {
                    pong.nextPlayer = pong.originalPlayer
                    pong.finishedPong = true
                } else {
                    pong.nextPlayer = nil
                }
            } else {
                let pong = Pong()
                pong.photos = [parsePhoto]
                pong.originalPlayer = user
                self.pong = pong
                pong.nextPlayer = nil
            }
            
            self.getRandomPlayer({ (player) -> (Void) in
                self.pong?.nextPlayer = player
                self.pong?.saveInBackgroundWithBlock { success, error in
                    print("get next player")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            })
            
            if (self.pong?.nextPlayer == nil) {
                self.getRandomPlayer({ (player) -> (Void) in
                    self.pong?.nextPlayer = player
                    self.pong?.saveInBackgroundWithBlock { success, error in
                        print("no player")
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                })
            } else {
                self.pong?.nextPlayer = self.pong?.originalPlayer
                self.pong?.finishedPong = true
                self.pong?.saveInBackgroundWithBlock({ (success, error) -> Void in
                    print("saved completed pong")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            }
        }
    }
    
    func getRandomPlayer(completion: (Player)->(Void)) {
        
        // get random player, set them to the nextPlayer, save
        // get count of players
        // get a random number between 0 and count
        
        if let countQuery = Player.query() {
//            countQuery.whereKeyDoesNotExist("nextPlayer")
//            countQuery.whereKey("originalPlayer", notEqualTo: Player.currentUser()!)
            countQuery.whereKey("objectId", notEqualTo: (Player.currentUser()?.objectId)!)
            countQuery.countObjectsInBackgroundWithBlock({ (count, error) in
                if error == nil {
                    if count == 0 {
                        self.savePong()
                    } else {
                        if let innerQuery = Player.query() {
//                            innerQuery.whereKeyDoesNotExist("nextPlayer")
//                            innerQuery.whereKey("originalPlayer", notEqualTo: Player.currentUser()!)
                            innerQuery.whereKey("objectId", notEqualTo: (Player.currentUser()?.objectId)!)
                            let randomIndex = arc4random_uniform(UInt32(count))
                            innerQuery.skip = Int(randomIndex)
                            innerQuery.limit = 1
                            innerQuery.findObjectsInBackgroundWithBlock { (objects, error) in
                                if error == nil {
                                    let randomIndex = arc4random_uniform(UInt32(objects!.count))
                                    let randomPlayer = objects![Int(randomIndex)]
                                    completion(randomPlayer as! Player)
                                    randomPlayer.saveInBackgroundWithBlock { success, error in
                                        print("random player picked")
                                    }
                                }
                            }
                        }
                    }
                }
            })
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
