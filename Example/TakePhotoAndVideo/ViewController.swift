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
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TakePhotoTool.sharedTool.setupPreViewLayer(view)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startTakeVideo(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            
            startTakeVideo()
            isTakeVideo = true
            count = 0
        } else if sender.state == UIGestureRecognizerState.ended {
            pause()
            startBtn.transform = CGAffineTransform.identity
            startBtn.draw(0.0)
            count = 0
            timeLabel.text = "点击拍照，长按录像"
            TakePhotoTool.sharedTool.stopTakeVideo()
        }
        print(sender.state)
    }
    @IBAction func take(_ sender: TakePhotoButton) {
        isTakeVideo = false
        timer = Timer(timeInterval: 0.01, target: self, selector: #selector(begin), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    } 

    @IBAction func startPhoto(_ sender: TakePhotoButton) {
        pause()
        count = 0
        startTakePhoto()
        sender.transform = CGAffineTransform.identity
    }
}


extension ViewController {
    @objc fileprivate func begin() {
        count += 1;
//        print(count)
        if isTakeVideo {//开始画圆并开始录像
            startBtn.draw(CGFloat(count) / 1000.0)
            timeLabel.text = "\(count / 100)" + "秒"
//            print("video")
            if count >= 1000 {
                pause()
                startBtn.draw(0.0)
                TakePhotoTool.sharedTool.stopTakeVideo()
            }
        } else {//开始拍照
            startBtn.transform = CGAffineTransform.init(scaleX: CGFloat(1 + CGFloat(count) / 400.0), y: CGFloat(1 + CGFloat(count) / 400.0))
        }
    }
    
    fileprivate func pause() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func startTakePhoto() {
        TakePhotoTool.sharedTool.takePhoto(view, { (image) in
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "play") as! PlayViewController
            vc.showType = .imageType
            vc.image = image
            self.present(vc, animated: false, completion: nil)
        })
    }
    fileprivate func startTakeVideo() {
        TakePhotoTool.sharedTool.takeVideo(view) { (fileUrl) in
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "play") as! PlayViewController
            vc.showType = .videoType
            vc.fileUrl = fileUrl
            self.present(vc, animated: false, completion: nil)
        }
    }
    
}
