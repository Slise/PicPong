//
//  PongIterationCell.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class PongIterationCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    //MARK: - Variables -
    
    var pong: Pong! {
        didSet {
            configure()
        }
    }
    var  pongNum:NSNumber = 0.0{
        didSet {
            configure()
        }
    }
    
    func configure() {
        let objectRef = pong
        postImageView.image = nil
         let lastObj = pong.photos[pongNum.integerValue] //{
            lastObj.pongImage.getDataInBackgroundWithBlock { data, error in
                if error == nil {
                    if self.pong == objectRef {
                        let image = UIImage(data: data!)
                        self.postImageView.image = image
                    }
              //  }
            }
        }
    }
}
