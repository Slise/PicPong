//
//  PongIterationView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class PongIterationView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pong: Pong?
   @NSManaged var pongID: String
    var pongIterations = [Pong]()
    
    //MARK: - Outlets -
    @IBOutlet weak var iterationCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.iterationCollectionView.reloadData()
    }
    
    //MARK: - UICollectionViewControllerDelegate Methods -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(300, 300)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pong!.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("iterationCell", forIndexPath: indexPath) as! PongIterationCell
        
        cell.postImageView.layer.borderWidth = 0
        cell.postImageView.image = nil
        
        cell.pong = pong
        cell.pongNum = indexPath.row
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PongIterationCell
        cell?.postImageView.layer.borderColor = UIColor.redColor().CGColor
        cell?.postImageView.layer.borderWidth = 4
        
        print("selectedItem is \(indexPath.item)")
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PongIterationCell
        cell?.postImageView.layer.borderWidth = 0
        
        print("selectedItem is \(indexPath.item)")

        
    }
    
    //MARK: - Actions -
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
        if let indexPath = iterationCollectionView.indexPathsForSelectedItems()?.first {
            let cell = iterationCollectionView.cellForItemAtIndexPath(indexPath) as? PongIterationCell
            if let image = cell?.postImageView.image {
                
                let shareVc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                
                if let presenter = shareVc.popoverPresentationController {
                    presenter.barButtonItem = sender
                }
                
                self.presentViewController(shareVc, animated: true, completion: nil)
            }

        }

        
        
        
    }
}
