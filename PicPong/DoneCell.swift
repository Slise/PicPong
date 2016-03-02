//
//  TaggedCell.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class DoneCell: UICollectionViewCell {
    
    //MARK: - Variables -
    
    var pong: Pong! {
        didSet {
            configure()
        }
    }

    //ACTIONS
    
    @IBOutlet weak var donePongImageView: UIImageView!
    
    // MARK: - General Functions -
    
    func configure() {
        let objectRef = pong
        donePongImageView.image = nil
        if let lastObj = pong.photos.last {
            lastObj.pongImage.getDataInBackgroundWithBlock { data, error in
                if error == nil {
                    if self.pong == objectRef {
                        let image = UIImage(data: data!)
                        self.donePongImageView.image = image
                    }
                    
                }
            }
        }
        
    }
}

