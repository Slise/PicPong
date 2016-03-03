//
//  DrawingView.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-24.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit

protocol DrawingViewDelegate: class {
    
    func imageEdited()
    func clearEdit()
}

class DrawingView: UIView {
    
    weak var delegate: DrawingViewDelegate?
    var drawingPath = UIBezierPath()
    var currentColour = UIColor.blackColor()
    
    var drawingPaths = [(UIBezierPath, UIColor)]()
    
    override func drawRect(rect: CGRect) {
        
        for (path, color) in drawingPaths {
            color.setStroke()
            path.stroke()
        }
        currentColour.setStroke()
        drawingPath.stroke()
    }
    
    func clear() {
        drawingPaths.removeAll()
        
        setNeedsDisplay()
        delegate?.clearEdit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawingPath.lineWidth = 4.0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchLocation = touches.first?.locationInView(self) {
            drawingPath.moveToPoint(touchLocation)
            delegate?.imageEdited()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchLocation = touches.first?.locationInView(self) {
            drawingPath.addLineToPoint(touchLocation)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        drawingPaths.append((drawingPath.copy() as! UIBezierPath, currentColour))
        drawingPath.removeAllPoints()
        setNeedsDisplay()
    }
}
