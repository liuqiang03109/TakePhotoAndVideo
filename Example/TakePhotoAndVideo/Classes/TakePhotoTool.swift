//
//  TakePhotoTool.swift
//  03-视频采集
//
//  Created by DanLi on 2017/3/20.
//  Copyright © 2017年 xmg. All rights reserved.
//


import UIKit
import AVFoundation
import AssetsLibrary


class TakePhotoTool: NSObject {
    static let sharedTool: TakePhotoTool = TakePhotoTool()
    ///输入和输出设备之间的数据会话
    fileprivate var session = AVCaptureSession()
    ///输入设备
    fileprivate var input: AVCaptureDeviceInput?
    ///预览图层
    fileprivate var preViewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var compeleted: ((URL) -> ())?
    
    ///图片输出流
    fileprivate var stillImageOutput = AVCaptureStillImageOutput()
    
    
    ///视频输出流
    fileprivate var videoOutput = AVCaptureVideoDataOutput()
    ///视频写入输出
    fileprivate var movieOutput = AVCaptureMovieFileOutput()
    
    fileprivate var fileURL : URL? {
        let str = String(format: "%d", Date(timeIntervalSinceNow: 0) as CVarArg)
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/\(str).mp4"
        return URL(fileURLWithPath: filePath)
    }
    
    override init() {
        super.init()
        setupInputAndOutput()
    }
    
}

extension TakePhotoTool {
    
    fileprivate func setupInputAndOutput() {
        guard let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] else {return}
        guard let device = devices.filter({$0.position == .back}).first else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else {return}
        self.input = input
        
        guard let preViewLayer = AVCaptureVideoPreviewLayer(session: session) else { return }
        //        preViewLayer.frame = view.bounds
        //        view.layer.insertSublayer(preViewLayer, at: 0)
        self.preViewLayer = preViewLayer
        
        setupImageInputAndOutput()
        
        setupVideoInputAndOutput()
        
        
    }
    private func setupImageInputAndOutput() {
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
    }
    
    private func setupVideoInputAndOutput() {
        
        let connection = movieOutput.connection(withMediaType: AVMediaTypeVideo)
        connection?.automaticallyAdjustsVideoMirroring = true
        
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        let output = AVCaptureAudioDataOutput()
        
        addInputAndOutput(input, output)
    }
    
    private func addInputAndOutput(_ input: AVCaptureDeviceInput, _ output: AVCaptureAudioDataOutput) {
        session.beginConfiguration()
        if session.canAddInput(self.input) {
            session.addInput(self.input)
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        if session.canAddOutput(movieOutput) {
            session.addOutput(movieOutput)
        }
        
        session.commitConfiguration()
    }
    
    
    fileprivate func getOrientation(_ orientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        if orientation == UIDeviceOrientation.landscapeLeft {
            return AVCaptureVideoOrientation.landscapeRight
        } else if (orientation == UIDeviceOrientation.landscapeRight) {
            return AVCaptureVideoOrientation.landscapeLeft
        } else {
            return AVCaptureVideoOrientation.portrait
        }
//        let library = ALAssetsLibrary()
//        library.writeVideoAtPath(toSavedPhotosAlbum: <#T##URL!#>, completionBlock: <#T##ALAssetsLibraryWriteVideoCompletionBlock!##ALAssetsLibraryWriteVideoCompletionBlock!##(URL?, Error?) -> Void#>)
//        UISaveVideoAtPathToSavedPhotosAlbum(<#T##videoPath: String##String#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
    }
    
    
}

// MARK - 对外暴露的方法
extension TakePhotoTool {
    
    open func setupPreViewLayer(_ inView: UIView) {
        preViewLayer?.frame = UIScreen.main.bounds
        print(inView.bounds)
        inView.layer.insertSublayer(preViewLayer!, at: 0)
        
        session.startRunning()
        
    }
    
    open func takePhoto(_ inView: UIView, _ compeleted: ((UIImage) -> ())?) {
        guard let connection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) else { return }
        let orientation = UIDevice.current.orientation
        let videoOrientation = getOrientation(orientation)
        connection.videoOrientation = videoOrientation
        stillImageOutput.captureStillImageAsynchronously(from: connection) { (imageDataSmapleBuffer, error) in
            if error != nil { return }
            guard let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSmapleBuffer) else { return }
            guard let image = UIImage(data: data) else { return }
            if compeleted != nil {
                self.preViewLayer?.removeFromSuperlayer()
                compeleted!(image)
            }
        }
    }
    
    open func takeVideo(_ inView: UIView, _ compeleted: ((URL) -> ())?) {
        movieOutput.startRecording(toOutputFileURL: fileURL, recordingDelegate: self)
        self.compeleted = compeleted 
    }
    
    open func stopTakeVideo() {
        session.stopRunning()
        movieOutput.stopRecording()
    }
    
    
}

extension TakePhotoTool: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("完成写入文件")
        if compeleted != nil {
            self.preViewLayer?.removeFromSuperlayer()
            compeleted!(outputFileURL)
        }
    }
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("开始写入文件")
    }
    
}

































