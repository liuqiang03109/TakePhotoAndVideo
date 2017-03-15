//
//  TakePhotoAndVideoView.swift
//  TakePhotoAndVideo
//
//  Created by DanLi on 2017/3/15.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class TakePhotoAndVideoView: UIView {
    fileprivate var count = 0
    fileprivate lazy var timer: Timer = {
        let timer = Timer(timeInterval: 0.01, target: self, selector: #selector(begin), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        return timer
    }()
    fileprivate var isTakeVideo = false
    fileprivate lazy var takeBtn: UIButton = {
        var button = UIButton(frame: CGRect(x: self.frame.width * 0.5, y: self.frame.height - 100, width: 50, height: 50))
//        let btn = UIButton()
        
//        UIImage(named: <#T##String#>)
//        btn.setBackgroundImage(, for: <#T##UIControlState#>)
        return button
    }()
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


}

extension TakePhotoAndVideoView {
    @objc fileprivate func begin() {
        count += 1
        
        
    }
    func pause() {
        timer.invalidate()
    }
    
    
}


