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
    
    // MARK: - Variables -
    
    var pongImageArray = [Pong]()
    var refreshControl: UIRefreshControl!
    let imagePicker = UIImagePickerController()
    
    // MARK: - Outlets -
    
    @IBOutlet weak var receivedPongCollectionView: UICollectionView!
    
    // MARK: - View Controler Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        setup()
        checkIfNeedsLogin()
        loadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        imageRefresh()
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
            guard let editPongVC = segue.destinationViewController as? EditPongViewController else { return }
            
            if let pongToPass = sender as? Pong {
                editPongVC.pong = pongToPass
            } else if let imageToPass = sender as? UIImage {
                editPongVC.image = imageToPass
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
            performSegueWithIdentifier("segueToEdit", sender: pongImageArray[indexPath.row-1])
        }
    }
    
//    func imageRefresh() {
//        getIncomingPong({ (player) -> Void in
//        })
//        self.refreshControl.endRefreshing()
//    }
    
//Mark: PFQuery to load incoming Pongs for collection view
    
//    func getIncomingPong(completion: (Player) -> Void) {
//        if let query = Pong.query() {
//            query.whereKeyDoesNotExist("nextPlayer")
//            query.includeKey("photos")
//            query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
//                
//                print("available pong for play \(object)")
//                if let pong = object as? Pong where error == nil {
//                    
//                    pong.nextPlayer = Player.currentUser()
//                    pong.saveInBackground()
//    
//                    if let lastPhoto = pong.photos.last {
//                        self.pongImageArray.append(lastPhoto)
//                    }
//                }
//                self.receivedPongCollectionView?.reloadData()
//            })
//        }
//    }
    
    // MARK: General Functions
    
    func loadData() {
        if let query = Pong.query() {
            query.whereKeyDoesNotExist("nextPlayer")
            
            query.findObjectsInBackgroundWithBlock{ objects, error in
                self.pongImageArray = objects as! [Pong]
                self.receivedPongCollectionView.reloadData()
            }
        }
    }
    
    func setup() {
        imagePicker.delegate = self
        receivedPongCollectionView?.alwaysBounceVertical = true
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("imageRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        receivedPongCollectionView.addSubview(refreshControl)
    }
    
    func checkIfNeedsLogin() {
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
}



//    func parseQuery() {
//        let query = Photo.query()
//        query?.orderByDescending("createdAt")
//        query?.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
//            if let photos = objects as? [Photo] where error == nil {
//                self.pongImageArray = photos
//                print("\(self.pongImageArray)")
//            }
//            self.receivedPongCollectionView?.reloadData()
//        }
//    }
//            let randomIndex = arc4random_uniform(UInt32(objects!.count))
//            let randomUser = objects![Int(randomIndex)]
//            completion(randomUser as! Player)

