//
//  ViewController.swift
//  AuthorizationEG
//
//  Created by luxu on 2019/3/19.
//  Copyright © 2019年 lx. All rights reserved.
//

import UIKit
import Alamofire
import CoreTelephony
import UserNotifications
import Photos
import AVFoundation
import CoreLocation
import Contacts
import AddressBook

class ViewController: UIViewController,CLLocationManagerDelegate {

    let cellularData = CTCellularData.init()
     let manager = CLLocationManager.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.requestVideoAuthorization()
//        self.requestNotificationAuthorization()
//        self.getNotificationAuthorization()
//        self.requestLocationAuthorization()
        self.requestContactAuthorization()
//        self.requestPhotoAuthorization()
        
//        if let image = UIImage.init(named: "test") {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let vc = UIImagePickerController.init()
//        vc.sourceType = .camera
//        self .present(vc, animated: true, completion: nil)
//    }
    
    func requestData() {
        // 应用首次请求网络的时候弹出权限提示框 就算卸载重新安装后再请求网络也不再会弹框 切换至系统设置更改权限app不受影响
        Alamofire.request("https://www.baidu.com")
    }
    
    func getTelephonyAuthorization() {
        // 获取网络权限状态
        let cellularData = CTCellularData.init()
        switch cellularData.restrictedState {
            case .restricted:
                print("restricted");
            case .notRestricted:
                print("notRestricted");
            case .restrictedStateUnknown:
                print("restrictedStateUnknown");
        }
    }
    
    func requestTelephonyAuthorization() {
        // 监听网络权限变化
        cellularData.cellularDataRestrictionDidUpdateNotifier = {state in
            switch state {
                case .restricted:
                    print("restricted");
                case .notRestricted:
                    print("notRestricted");
                case .restrictedStateUnknown:
                    print("restrictedStateUnknown");
            }
        }
    }
    
    func getNotificationAuthorization() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                switch settings.authorizationStatus.rawValue {
                case 0:
                    print("not authorized")
                default:
                    print("authorized")
                }
            }
        }else {
            guard let settings = UIApplication.shared.currentUserNotificationSettings else {
                print("not settings");
                return;
            }
            switch settings.types.rawValue {
            case 0:
                print("not authorized")
            default:
                print("authorized")
            }
        }
    }
    
    func requestNotificationAuthorization() {
        // 首次使用会弹出权限提示框 卸载重装后首次使用也会弹框  切换至系统设置更改权限app不受影响
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
                if granted {
                    print("authorized");
                }else {
                    print("not authorized");
                }
            }
        } else {
            let setting = UIUserNotificationSettings.init(types: [.alert,.sound,.badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
    }
    
    
    func getLocationAuthorization() {
        if !CLLocationManager.locationServicesEnabled() {
            print("disenable")
            return;
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
            case .authorizedAlways:
                print("always")
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
            case .denied:
                print("denied")
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
        }
    }
    
    func requestLocationAuthorization() {
        // 首次使用会弹出权限提示框 卸载重装后首次使用也会弹框  切换至系统设置更改权限app不受影响 NSLocationAlwaysAndWhenInUseUsageDescription NSLocationWhenInUseUsageDescription可空  切换至系统设置更改权限app不受影响
//        manager = CLLocationManager.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        }
    }
    
    func getContactAuthorization() {
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            // ...
        }else {
            let status = ABAddressBookGetAuthorizationStatus()
            // ...
        }
    }
    
    func requestContactAuthorization() {
        // 首次使用会弹出权限提示框 卸载重装后首次使用也会弹框  切换至系统设置更改权限app不受影响  NSContactsUsageDescription可空  切换至系统设置更改权限app将被kill
        if #available(iOS 9.0, *) {
            let contact = CNContactStore.init()
            contact.requestAccess(for: .contacts) { (granted, error) in
                // ...
            }
        }else {
            let addressBook = ABAddressBookCreateWithOptions(nil, nil)
            ABAddressBookRequestAccessWithCompletion(addressBook as ABAddressBook) { (granted, error) in
                // ...
            }
        }
    }
    
    func getVideoAuthorization() {
        let videoAuthorStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch videoAuthorStatus {
            case .authorized:
                print("authorized");
            case .denied:
                print("denied");
            case .notDetermined:
                print("notDetermined");
            case .restricted:
                print("restricted");
        }
    }
    
    func requestVideoAuthorization() {
        // 请求权限 首次使用会弹出权限提示框 卸载重装后首次使用也会弹框 NSCameraUsageDescription可空  切换至系统设置更改权限app将被kill
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
            if granted {
                print("authorized");
            }else {
                print("not authorized");
            }
        })
    }
    
    func getPhotoAuthorization() {
        let photoAuthorStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorStatus {
            case .authorized:
                print("authorized");
            case .denied:
                print("denied");
            case .notDetermined:
                print("notDetermined");
            case .restricted:
                print("restricted");
            }
    }
    
    func requestPhotoAuthorization() {
        // 请求权限 首次使用会弹出权限提示框 卸载重装后首次使用也会弹框 NSPhotoLibraryUsageDescription可空  切换至系统设置更改权限app将被kill
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.authorized {
                print("authorized");
            }else {
                print("not authorized");
            }
        }
    }
    
}

