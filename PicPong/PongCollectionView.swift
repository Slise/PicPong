//
//  PongCollectionView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class PongCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate {
    
    //MARK: - Variables -
    
    var pong = Pong()
    var donePongArray = [Pong]()
    var refreshControl: UIRefreshControl!
    
    //MARK: - Outlets -
    
    @IBOutlet weak var pongCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donePongs()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        addRefreshControl()
    }
    
    //MARK: - UICollectionViewControllerDelegate Methods -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150, 150)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donePongArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("finishedPongCell", forIndexPath: indexPath) as! DoneCell
        cell.pong = donePongArray[indexPath.row]
        return cell
            }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        pong = donePongArray[indexPath.row]
        performSegueWithIdentifier("segueToIteration", sender: self)
            }
    
    //MARK: - General Methods -
    
    func donePongs() {
        if let query = Pong.query() {
            query.whereKey("finishedPong", equalTo: true)
            query.includeKey("photos")
            query.findObjectsInBackgroundWithBlock{ objects, error in
                self.donePongArray = objects as! [Pong]
                self.pongCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    func myDonePongs() {
        if let query = Pong.query() {
            query.whereKey("finishedPong", equalTo: true)
            query.whereKey("originalPlayer", equalTo: Player.currentUser()!)
            query.includeKey("photos")
            query.findObjectsInBackgroundWithBlock{ objects, error in
                self.donePongArray = objects as! [Pong]
                self.pongCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("donePongs"), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        pongCollectionView.addSubview(refreshControl)
    }
    
    //MARK: - Actions -
    
    @IBAction func donePongFilter(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            donePongs()
        case 1:
            myDonePongs()
        default:
            break;
        }
    }
    
    //MARK: - Segues -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToIteration" {
            if let pongIterationVC = segue.destinationViewController as? PongIterationView {
                pongIterationVC.pong = pong
            }
        }
    }
}

