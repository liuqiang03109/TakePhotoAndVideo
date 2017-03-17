//
//  ViewController.swift
//  TakePhotoAndVideo
//
//  Created by liuqiang03109 on 03/15/2017.
//  Copyright (c) 2017 liuqiang03109. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startBtn: TakePhotoButton!
    
    fileprivate var count = 0
    
    fileprivate var timer: Timer?
    fileprivate var isTakeVideo = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startTakeVideo(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            isTakeVideo = true
        } else if sender.state == UIGestureRecognizerState.ended {
            pause()
            sender.view!.transform = CGAffineTransform.identity
            startBtn.draw(0.0)
        }
        count = 0
    }
    @IBAction func take(_ sender: TakePhotoButton) {
        isTakeVideo = false
        timer = Timer(timeInterval: 0.01, target: self, selector: #selector(begin), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    } 

    @IBAction func startPhoto(_ sender: TakePhotoButton) {
        pause()
        count = 0
        
        sender.transform = CGAffineTransform.identity
    }
}


extension ViewController {
    @objc fileprivate func begin() {
        count += 1;
        if isTakeVideo {//开始画圆并开始录像
            startBtn.draw(CGFloat(count) / 1000.0)
            if count == 1000 {
                pause()
                startBtn.draw(0.0)
            }
        } else {//开始拍照
            startBtn.transform = CGAffineTransform.init(scaleX: CGFloat(1 + CGFloat(count) / 200.0), y: CGFloat(1 + CGFloat(count) / 200.0))
        }
    }
    
    fileprivate func pause() {
        timer?.invalidate()
        timer = nil
    }
    
    
}
