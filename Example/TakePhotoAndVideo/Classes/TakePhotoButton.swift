//
//  TakePhotoButton.swift
//  TakePhotoAndVideo
//
//  Created by DanLi on 2017/3/17.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class TakePhotoButton: UIButton {
 
    fileprivate var progress: CGFloat = 0
    fileprivate let progessLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineWidth = 2
        return layer
    }()
    
    
    internal override func draw(_ rect: CGRect) {
        let width: CGFloat = 4
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let radius = (bounds.width - width) * 0.5
        print(frame, "---------", center, ">>>>>>", radius)
        let startPoint: CGFloat = -(CGFloat)(M_PI_2)
        let endPoint: CGFloat = -(CGFloat)(M_PI_2) + (CGFloat)(M_PI) * 2 * progress
        progessLayer.frame = bounds
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        progessLayer.path = path.cgPath
        layer.addSublayer(progessLayer)
    } 

}

extension TakePhotoButton {
    func draw(_ progress: CGFloat) {
        self.progress = progress
        
        setNeedsDisplay()
    }
}

