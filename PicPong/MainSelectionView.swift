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

class MainSelectionView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var receivedPongCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        self.imagePicker.delegate = self
        parseQuery()
    }
    
// MARK: - UIImagePickerControllerDelegate Methods
    let imagePicker = UIImagePickerController()
    
    func getPongImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if let imageData = UIImageJPEGRepresentation(image, 0.50) {
        let imageFile = PFFile(name:"pong.png", data:imageData)
        let pong = PFObject(className:"Photo")
        pong["pongImage"] = imageFile
        pong.saveInBackground()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        goToEditPong()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goToEditPong() {
        performSegueWithIdentifier("segueToEdit", sender: self)
    }

//MARK: UICollectionViewControllerDelegate Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pongImageArray.count+1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = (indexPath.item == 0) ? "cameraCell" : "pongCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        cell.pongImageView.image = nil
        let incomingPong = pongImageArray[indexPath.item]
    return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            getPongImage()
            
        }else {
            goToEditPong()
        }
    }
    
//Mark: PFQuery to load to collection view
    var pongImageArray:NSArray = NSArray()
    var refreshControl: UIRefreshControl!
    
    func parseQuery() {
        let query = Photo.query()
//        query.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if error == nil {
                self.pongImageArray = objects!
                print("\(self.pongImageArray)")
            }
            self.receivedPongCollectionView?.reloadData()
        }
    }
    
    func imageRefresh() {
        parseQuery()
        self.refreshControl.endRefreshing()
    }
}