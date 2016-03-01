//
//  PongIterationCell.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-23.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class PongIterationCell: UICollectionViewCell {
    
    //MARK: - Variables -
    
    var pong: Pong! {
        didSet {
            configure()
        }
    }

    @IBOutlet weak var pongIterationImage: UIImageView!
    
    func configure() {
        let objectRef = pong
        pongIterationImage.image = nil
        pong.photos.last!.pongImage.getDataInBackgroundWithBlock { data, error in
            if error == nil {
                if self.pong == objectRef {
                    let image = UIImage(data: data!)
                    self.pongIterationImage.image = image
                }
            }
        }
    }

}
