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
        tabBarIsVisible()
        loadData()
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func showImagePicker() {
        let cameraVC = UIAlertController(title: "Pong Selection", message: "please select an image from camera or photo library", preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
        cameraVC.addAction(cancel)
        let cameraSource = UIAlertAction(title: "camera", style: .Default, handler: { (_: UIAlertAction) -> Void in
            self.showImagePicker(UIImagePickerControllerSourceType.Camera)
        })
        cameraVC.addAction(cameraSource)
        let photoGallery = UIAlertAction(title: "gallery", style: .Default, handler: { (_:UIAlertAction) -> Void in
            self.showImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
        })
        cameraVC.addAction(photoGallery)
        
        if let presenter = cameraVC.popoverPresentationController {
            let ip = NSIndexPath(forRow: 0, inSection: 0)
            let cell = collectionView(receivedPongCollectionView, cellForItemAtIndexPath: ip)
            
            presenter.sourceView = cell;
            presenter.sourceRect = cell.frame;
        }
        self.presentViewController(cameraVC, animated: true, completion:nil)
    }
    
    func showImagePicker(type: UIImagePickerControllerSourceType) {
        let imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false
        imageFromSource.sourceType = type
        self.presentViewController(imageFromSource, animated: true, completion:nil)
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
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

//MARK: UICollectionViewControllerDelegate Methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150, 150)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pongImageArray.count+1
    }

    let cameraCellIdentifier = "cameraCell"
    let pongCellIdentifier = "pongCell"
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = indexPath.item == 0 ? cameraCellIdentifier : pongCellIdentifier
        
        if reuseIdentifier == pongCellIdentifier {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PongCell
            cell.pong = pongImageArray[indexPath.row-1]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            showImagePicker()
        } else {
            performSegueWithIdentifier("segueToEdit", sender: pongImageArray[indexPath.row-1])
        }
    }
    
    // MARK: General Functions
    
    func loadData() {
        if let query = Pong.query() {
            if let currentPlayer = Player.currentUser() {
                query.whereKey("nextPlayer", equalTo: currentPlayer)
            }
            query.whereKey("isFinished", notEqualTo: true)
            query.includeKey("photos")
            query.findObjectsInBackgroundWithBlock{(object, error) in
                self.pongImageArray = object as! [Pong]
                self.receivedPongCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setup() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        receivedPongCollectionView?.alwaysBounceVertical = true
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
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
    
    // MARK: - Segues -
    
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
    
    @IBAction func unwindToMainScreen(segue:UIStoryboardSegue) {
        
    }
}
