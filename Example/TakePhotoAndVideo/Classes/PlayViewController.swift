//
//  PlayViewController.swift
//  03-视频采集
//
//  Created by DanLi on 2017/3/20.
//  Copyright © 2017年 xmg. All rights reserved.
//

import UIKit
import AVFoundation

enum ShowType {
    
    case imageType
    
    case videoType
    
}

class PlayViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var showType: ShowType!
    var fileUrl: URL?
    var image: UIImage?
    fileprivate var player: AVPlayer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showType == .imageType {
            if let image = image {
                imageView.isHidden = false
                imageView.image = image
            }
        } else {
            if let fileUrl = fileUrl {
                player = AVPlayer(url: fileUrl)
               
                let playerLayer = AVPlayerLayer(player: player)
                
                playerLayer.frame = view.bounds
                
                view.layer.insertSublayer(playerLayer, at: 0)
            
                player?.play()
                addNotification()
            }
        }
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(UIButton())
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }

}


extension PlayViewController {
    fileprivate func addNotification() {
         
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc private func playbackFinished(_ noti: Notification) {
        player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        player?.play()
    }
    
}






