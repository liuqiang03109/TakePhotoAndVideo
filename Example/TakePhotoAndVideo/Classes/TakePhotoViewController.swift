//
//  TakePhotoViewController.swift
//  03-视频采集
//
//  Created by DanLi on 2017/3/20.
//  Copyright © 2017年 xmg. All rights reserved.
//

import UIKit
import AVFoundation

class TakePhotoViewController: UIViewController {

    
    @IBOutlet weak var controllView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    } 
    
    @IBAction func takeVideo(_ sender: UIButton) {
        
        sender.isSelected ? TakePhotoTool.sharedTool.stopTakeVideo() : TakePhotoTool.sharedTool.takeVideo(view, {[weak self] (fileUrl) in
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "play") as! PlayViewController
            vc.showType = .videoType
            vc.fileUrl = fileUrl
            self?.present(vc, animated: false, completion: nil)
            
        })
        sender.isSelected = !sender.isSelected
        
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        TakePhotoTool.sharedTool.takePhoto(view) { (image) in
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "play") as! PlayViewController
            vc.showType = .imageType
            vc.image = image
            self.present(vc, animated: false, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TakePhotoTool.sharedTool.setupPreViewLayer(view)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension TakePhotoViewController {
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}









