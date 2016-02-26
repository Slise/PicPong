//
//  DrawingView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-24.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    
    var drawingPath = UIBezierPath()
    
    override func drawRect(rect: CGRect) {
        UIColor.redColor().setStroke()
        drawingPath.stroke()
    }
    
    func clear() {
        drawingPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        drawingPath.lineWidth = 2.0
      
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchLocation = touches.first?.locationInView(self) {
            drawingPath.moveToPoint(touchLocation)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchLocation = touches.first?.locationInView(self) {
            drawingPath.addLineToPoint(touchLocation)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}
