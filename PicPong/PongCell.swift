//
//  PongCell.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class PongCell: UICollectionViewCell {
    
    // MARK: - Variables -
    
    var pong: Pong! {
        didSet {
            configure()
        }
    }
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var pongImageView: UIImageView!
    
    // MARK: - General Functions -
    
    func configure() {
        let objectRef = pong
        pongImageView.image = nil
        pong.photos.last!.pongImage.getDataInBackgroundWithBlock { data, error in
            if error == nil {
                if self.pong == objectRef {
                    let image = UIImage(data: data!)
                    self.pongImageView.image = image
                }
            }
        }
    }
}
