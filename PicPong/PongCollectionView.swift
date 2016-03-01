//
//  PongCollectionView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class PongCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - Variables -
    
    var donePongArray = [Pong]()
    var refreshControl: UIRefreshControl!
    
    //MARK: - Outlets -
    
    @IBOutlet weak var pongCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        donePongs()
    }
    
    override func viewWillAppear(animated: Bool) {
        donePongs()
        addRefreshControl()
    }
    
    //MARK: - UICollectionViewControllerDelegate Methods -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(110, 110)
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
        
            }
    
    //MARK: - General Methods -
    
    func donePongs() {
//        if let query = Pong.query() {
//            query.whereKey("nextPlayer", equalTo: "originalPoster")
//            query.includeKey("photos")
//            query.findObjectsInBackgroundWithBlock{ objects, error in
//                self.donePongArray = objects as! [Pong]
//                self.pongCollectionView.reloadData()
//                self.refreshControl.endRefreshing()
//            }
//        }
    }
    
    func myDonePongs() {
        if let query = Pong.query() {
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
        refreshControl.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
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
            guard let editPongVC = segue.destinationViewController as? PongIterationView else { return }
            
            if let pongToPass = sender as? Pong {
                editPongVC.pong = pongToPass
            }
        }
    }
    
}
