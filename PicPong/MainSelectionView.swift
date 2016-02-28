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
    var pongImageArray = [Photo]()
    var refreshControl: UIRefreshControl!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("imageRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.receivedPongCollectionView?.addSubview(refreshControl)
        self.imagePicker.delegate = self
        receivedPongCollectionView?.alwaysBounceVertical = true
        self.view.addSubview(receivedPongCollectionView!)
        parseQuery()
        let pongPlayer = Player.currentUser()
        if pongPlayer == nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let loginVC:UIViewController = UIStoryboard(name: "DesignSprint", bundle: nil).instantiateViewControllerWithIdentifier("LogInViewController") as UIViewController
                self.showViewController(loginVC, sender: self)
            })
        } else {
            print("User \(pongPlayer?.username) is logged in")
        }
    }

    override func viewWillAppear(animated: Bool) {
        parseQuery()
    }
    
// MARK: - UIImagePickerControllerDelegate Methods
    func createPongImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            performSegueWithIdentifier("segueToEdit", sender: image)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToEdit" {
            let editPongVC = segue.destinationViewController as! EditPongViewController
            if let image = sender as? UIImage {
                editPongVC.image = image
            }
        }
    }

//MARK: UICollectionViewControllerDelegate Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pongImageArray.count+1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = (indexPath.item == 0) ? "cameraCell" : "pongCell"
        
        if reuseIdentifier == "pongCell" {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PongCell
            cell.pongImageView.image = nil
            let index = indexPath.item-1
            let incomingPong = pongImageArray[index]
            incomingPong.pongImage.getDataInBackgroundWithBlock{(data, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    cell.pongImageView.image = image
                }
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            createPongImage()
        }else {
            
        }
    }
    
//Mark: PFQuery to load to collection view
    func parseQuery() {
        let query = Photo.query()
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            
            if let photos = objects as? [Photo] where error == nil {
                self.pongImageArray = photos
                print("\(self.pongImageArray)")
            }
            self.receivedPongCollectionView?.reloadData()
        }
    }
    
    func imageRefresh() {
        parseQuery()
        getNextPlayer({ (player) -> Void in
        })
        self.refreshControl.endRefreshing()
    }
    
    func getNextPlayer(completion: (Player) -> Void) {
        if let query = Player.query(),
            let user = Player.currentUser() {
                query.whereKey("objectId", equalTo: user.objectId!)
                query.findObjectsInBackgroundWithBlock { (objects, error) in
                    let randomIndex = arc4random_uniform(UInt32(objects!.count))
                    let randomUser = objects![Int(randomIndex)]
                    completion(randomUser as! Player)
                }
        }
        
    }

}