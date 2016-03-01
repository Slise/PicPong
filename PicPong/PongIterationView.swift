//
//  PongIterationView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class PongIterationView: UIViewController {
    
    var pong: Pong?
    var pongIterations = [Pong]()
    
    //MARK: - Outlets -
    @IBOutlet weak var iterationCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - UICollectionViewControllerDelegate Methods -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(200, 200)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pongIterations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("iterationCell", forIndexPath: indexPath) as! PongIterationCell
        cell.pong = pongIterations[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func pongIterationCollection() {
        if let query = Pong.query() {
            query.whereKey("originalPlayer", equalTo: Player.currentUser()!)
            query.includeKey("photos")
            query.findObjectsInBackgroundWithBlock{ objects, error in
                self.pongIterations = objects as! [Pong]
                self.iterationCollectionView.reloadData()
            }
        }
    }

}
