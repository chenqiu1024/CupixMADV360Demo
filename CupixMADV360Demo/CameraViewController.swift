//
//  CameraViewController.swift
//  CupixMADV360Demo_Swift
//
//  Created by QiuDong on 2018/9/28.
//  Copyright © 2018年 QiuDong. All rights reserved.
//

import Foundation
import UIKit

enum PanoramaDisplayMode : Int32 {
    case Plain = 0x00 // No projection, just draw input texture as it is
    case Sphere = 0x01 // Normal mode: Camera at centre of the panorama sphere
    case Planet = 0x02 // Asteroid mode: Camera at north pole of the panorama sphere, and with wider FOV
    case StereoGraphic = 0x03 // Fisheye mode: Camera at back point on the panorama sphere
    case Panorama = 0x04
    case CrystalBall = 0x05
}

@objc(CameraViewController) class CameraViewController : MVKxMovieViewController, MVCameraClientObserver, MVMediaDataSourceObserver, MVMediaDownloadStatusObserver {
    
    @IBOutlet weak var connectButton:UIButton!
    @IBOutlet weak var shootButton:UIButton!
    @IBOutlet weak var voltageLabel:UILabel!
    @IBOutlet weak var storageLabel:UILabel!
    @IBOutlet weak var viewModeButton:UIButton!
    
    var device:MVCameraDevice?
    
    @IBAction func onConnectButtonClicked(_ sender:Any) {
        if (self.connectButton.tag == 0) {
            self.connectButton.isEnabled = false
            self.connectButton.setTitle("Connecting...", for: UIControlState.normal)
            MVCameraClient.sharedInstance()?.connectCamera()
        }
        else {
            self.connectButton.isEnabled = false
            self.connectButton.setTitle("Disconnecting...", for: UIControlState.normal)
            MVCameraClient.sharedInstance()?.disconnectCamera()
        }
    }
    
    @IBAction func onShootButtonClicked(_ sender:Any) {
        MVCameraClient.sharedInstance()?.startShooting()
        self.shootButton.isEnabled = false
        self.shootButton.setTitle("Shooting...", for: UIControlState.normal)
    }
    
    @IBAction func onViewModeButtonClicked(_ sender:Any) {
        switch (self.glView.panoramaMode)
        {
        case PanoramaDisplayMode.StereoGraphic.rawValue:
            self.glView.panoramaMode = PanoramaDisplayMode.Sphere.rawValue;
            self.viewModeButton.setTitle("ViewMode:Sphere", for:UIControlState.normal);
        case PanoramaDisplayMode.Sphere.rawValue:
            self.glView.panoramaMode = PanoramaDisplayMode.Planet.rawValue;
            self.viewModeButton.setTitle("ViewMode:Planet", for:UIControlState.normal);
        case PanoramaDisplayMode.Planet.rawValue:
            self.glView.panoramaMode = PanoramaDisplayMode.CrystalBall.rawValue;
            self.viewModeButton.setTitle("ViewMode:CrystalBall", for:UIControlState.normal);
        case PanoramaDisplayMode.CrystalBall.rawValue:
            self.glView.panoramaMode = PanoramaDisplayMode.Panorama.rawValue;
            self.viewModeButton.setTitle("ViewMode:Panorama", for:UIControlState.normal);
        case PanoramaDisplayMode.Panorama.rawValue:
            self.glView.panoramaMode = PanoramaDisplayMode.StereoGraphic.rawValue;
            self.viewModeButton.setTitle("ViewMode:StereoGraphic", for:UIControlState.normal);
        default:
            break;
        }
    }
    
    // MVCameraClientObserver:
    func willConnect() {
        
    }
    
    func didSetWifi(_ success: Bool, errMsg: String!) {
        
    }
    
    func didRestartWifi(_ success: Bool, errMsg: String!) {
        
    }
    
    func willDisconnect(_ reason: CameraDisconnectReason) {
        
    }
    
    func didVoltagePercentChanged(_ percent: Int32, isCharging: Bool) {
        self.voltageLabel.text = "Voltage:\(percent)%\(isCharging ? " Charging":"")";
    }
    
    func didSwitchCameraModeFail(_ errMsg: String!) {
        
    }
    
    func didBeginShooting(_ error: Int32, numberOfPhoto: Int32) {
        
    }
    
    func didShootingTimerTick(_ shootTime: Int32, videoTime: Int32) {
        
    }
    
    func didCountDownTimerTick(_ timingStart: Int32) {
        
    }
    
    func didSDCardSlowlyWrite() {
        
    }
    
    func didStopShooting(_ error: Int32) {
        
    }
    
    func didSettingsChange(_ optionUID: Int32, paramUID: Int32, errMsg: String!) {
        
    }
    
    func didReceiveAllSettingItems(_ errorCode: Int32) {
        
    }
    
    func didWorkStateChange(_ workState: CameraWorkState) {
        
    }
    
    func didStorageMountedStateChanged(_ mounted: StorageMountState) {
        print("didStorageMountedStateChanged : SD card mounted = \(mounted)");
        let cameraClient:MVCameraClient = MVCameraClient.sharedInstance();
        if (mounted != StorageMountStateNO)
        {
            self.storageLabel.text = "free/total : \(cameraClient.freeStorage)/\(cameraClient.totalStorage)";
        }
        else
        {
            self.storageLabel.text = "No SDCard";
        }
    }
    
    func didStorageStateChanged(_ newState: StorageState, oldState: StorageState) {
        
    }
    
    func didStorageTotalFreeChanged(_ total: Int32, free: Int32) {
        self.storageLabel.text = "free/total : \(free)/\(total)";
    }
    
    func didReceiveCameraNotification(_ notification: String!) {
        
    }
    
    func didAdjustedCameraGyro(_ errorCode: Int32) {
        
    }
    
    func didConnectSuccess(_ device: MVCameraDevice!) {
        self.setContentPath("rtsp://192.168.42.1/live", parameters:nil)
        self.connectButton.tag = 1;
        self.connectButton.isEnabled = true;
        self.connectButton.setTitle("Disconnect", for: UIControlState.normal)
        self.shootButton.isHidden = false;
        self.voltageLabel.text = "Voltage:\(device.voltagePercent)%\(device.isCharging ? " Charging":"")";
        let cameraClient:MVCameraClient = MVCameraClient.sharedInstance();
        if (cameraClient.storageMounted != StorageMountStateNO)
        {
            self.storageLabel.text = "free/total : \(cameraClient.freeStorage)/\(cameraClient.totalStorage)";
        }
        else
        {
            self.storageLabel.text = "No SDCard";
        }
        self.viewModeButton.setTitle("ViewMode:StereoGraphic", for:UIControlState.normal);
    }
    
    func didDisconnect(_ reason: CameraDisconnectReason) {
        self.connectButton.tag = 0;
        self.connectButton.isEnabled = true;
        self.connectButton.setTitle("Connect", for: UIControlState.normal)
        self.shootButton.isHidden = true;
    }

    func didConnectFail(_ object: Any!) {
        self.didDisconnect(CameraDisconnectReasonUnknown)
    }
    
    func didCameraModeChange(_ mode: CameraMode, subMode: CameraSubMode, param: Int) {
        if (mode != CameraModePhoto || subMode != CameraSubmodePhotoNormal)
        {
            //#MADVSDK# Change to Normal Photo Shooting mode if the camera is not at it:
            MVCameraClient.sharedInstance()?.setCameraMode(CameraModePhoto, subMode: CameraSubmodePhotoNormal, param:0)
        }
    }
    
    func didEndShooting(_ remoteFilePath: String!, videoDurationMills: Int, error: Int32, errMsg: String!) {
        self.shootButton.isEnabled = true
        self.shootButton.setTitle("Shoot", for: UIControlState.normal)
    }

    func didCameraMediasReloaded(_ medias: [MVMedia]!, dataSetEvent: DataSetEvent, errorCode: Int32) {
        if (dataSetEvent == DataSetEventAddNew)
        {// As new picture file(s) generated by the camera, immediately start downloading:
            print("addDownloadingOfMedias : \(medias as [MVMedia])")
            let mediaManager = MVMediaManager.sharedInstance() as! MVMediaManager
            mediaManager.addDownloading(of: medias, completion: {
                print("Downloading finished")
            }) { (completedCount:Int32, totalCount:Int32, cancel:UnsafeMutablePointer<ObjCBool>?) in
                //                cancel?.pointee = false
                print("Downloading: \(completedCount)/\(totalCount)")
            }
        }
    }
    
    // MVMediaDataSourceObserver:
    /**
     * 本地媒体列表有更新
     * @param medias : 发生变化的本地媒体对象列表
     * @param dataSetEvent : 见#DataSetEvent#枚举，表示发生变化的对象列表是新增抑或删除抑或替换抑或全部刷新
     */
    func didLocalMediasReloaded(_ medias: [MVMedia]!, dataSetEvent: DataSetEvent) {
        
    }
    
    /** 异步获取媒体缩略图的回调
     * media: 需要获取缩略图的媒体对象对象
     * image: 缩略图
     */
    func didFetchThumbnailImage(_ image: UIImage!, of media: MVMedia!, error: Int32) {
        
    }
    
    /**
     * 异步获取媒体信息的回调
     * @param media 获取到媒体信息的媒体对象，可以从其中用get方法读取视频时长等信息
     */
    func didFetchMediaInfo(_ media: MVMedia!, error: Int32) {
        
    }
    
    /** 异步获取到最近拍摄的一个媒体文件的缩略图
     * @param media 获取到媒体信息的媒体对象，可以从其中用get方法读取视频时长等信息
     * @param image 缩略图UIImage对象
     */
    func didFetchRecentMediaThumbnail(_ media: MVMedia!, image: UIImage!, error: Int32) {
        
    }
    
    // MVMediaDownloadStatusObserver:
    func didDownloadStatusChange(_ downloadStatus: Int32, errorCode: Int32, of media: MVMedia!) {
        if (errorCode == 0 && MVMediaDownloadStatusFinished == MVMediaDownloadStatus(Int(downloadStatus)))
        {
            print("Media downloaded, localPath='\(media.localPath as String)'")
            let ext = URL(fileURLWithPath: media.localPath)
            if (ext.pathExtension.lowercased() == "jpg")
            {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                var sourcePath:String, destPath:String
                if ((MVMediaManager.sharedInstance() as! MVMediaManager).noStitchingAfterPhotoDownloaded)
                {
                    sourcePath = documentsPath.appending("/\(media.localPath as String).\(media.cameraUUID as String).prestitch.jpg")
                    destPath = documentsPath.appending("/\(media.localPath as String).stitched.jpg")
                }
                else
                {
                    sourcePath = documentsPath.appending("/\(media.localPath as String)")
                    destPath = sourcePath.appending(".stitched.jpg")
                }
                // Create(if not exists) a temporary path for storing LUT data files, which will be deleted after stitching:
                let tempLUTDirectory = makeTempLUTDirectory(sourcePath)
                // Pass (0,0) as (destWidth,destHeight) to make stitched image exactly the same size as the original one:
                DispatchQueue.global(qos: .default).async {
                    renderMadvJPEGToJPEG(destPath, sourcePath, tempLUTDirectory, 0, 0, false)
                    do {
                        try FileManager.default.removeItem(atPath: sourcePath)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    /** 多项媒体文件的下载状态发生批量变化（发生在下载管理页面用户批量操作时）
     *
     */
    func didBatchDownloadStatusChange(_ downloadStatus: Int32, of medias: [MVMedia]!) {
        
    }
    
    /** 下载进度通知回调
     * media: 发生下载进度变化的媒体对象
     */
    func didDownloadProgressChange(_ downloadedBytes: Int, totalBytes: Int, of media: MVMedia!) {
        
    }
    
    /**
     * 因相机开始录像而主动暂停下载时，回调到此方法
     */
    func didDownloadingsHung() {
        
    }
    
    func didReceiveStorageWarning() {
        
    }
    
    // Should override this method just like this:
    override func didSetupPresentView(_ newGLView:UIView!) {
        var presentView:MVGLView? = nil
        self.view.traverseMeAndSubviews { (view:UIView?) in
            if (view is MVGLView)
            {
                presentView = view as! MVGLView?
            }
        }
        if (nil == presentView) {
            presentView = newGLView as! MVGLView?
            self.view.addSubview(presentView!)
        }
        self.view.sendSubview(toBack: presentView!)
        
        presentView?.contentMode = UIViewContentMode.scaleAspectFit
        presentView?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleHeight]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MVCameraClient.sharedInstance()?.add(self)
        let mediaManager:MVMediaManager = MVMediaManager.sharedInstance() as! MVMediaManager;
        // Whether download pictures into Documents directory or move to photo library of iOS device:
        mediaManager.downloadMediasIntoDocuments = true
        // Whether download original picture only(for your need) or stitch right after downloaded:
        mediaManager.noStitchingAfterPhotoDownloaded = true
        // Add as observer for media manager:
        mediaManager.add(self as MVMediaDataSourceObserver)
        mediaManager.add(self as MVMediaDownloadStatusObserver)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MVCameraClient.sharedInstance()?.remove(self)
        let mediaManager:MVMediaManager = MVMediaManager.sharedInstance() as! MVMediaManager
        mediaManager.remove(self as MVMediaDataSourceObserver)
        mediaManager.remove(self as MVMediaDownloadStatusObserver)
    }
}
