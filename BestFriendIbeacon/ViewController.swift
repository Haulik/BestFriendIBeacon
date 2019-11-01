//
//  ViewController.swift
//  BestFriendIbeacon
//
//  Created by Thomas Haulik Barchager on 25/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications


class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    //let locationManager:CLLocationManager = CLLocationManager()
    let uuid = UUID(uuidString: "20CAE8A0-A9CF-11E3-A5E2-0800200C9A66")
    let major = CLBeaconMajorValue(234)
    let minor = CLBeaconMinorValue(55967) // 56850
    let locationManager = CLLocationManager()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        rangeBeacon()
    }
    
    func rangeBeacon() {
        let region = CLBeaconRegion(uuid: uuid!, major: major, minor: minor, identifier: "kea")
        
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            
        }
    }
    

    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoveredBeaconProximity = beacons.first?.proximity else {print("coudnot find the beacons"); return }
        
        let backgroundColor:UIColor = {
            switch discoveredBeaconProximity {
            case .immediate :
                
                postLocalNotifications(eventTitle: "Immediate: \(region.identifier)")
            
                return UIColor.green
            case .near:
               // postLocalNotifications(eventTitle: "near: \(region.identifier)")
                return UIColor.orange
            case .far:
               // postLocalNotifications(eventTitle: "Far: \(region.identifier)")
                return UIColor.red
            case .unknown:
              //  postLocalNotifications(eventTitle: "unknown: \(region.identifier)")
                return UIColor.black
            }
        }()
        view.backgroundColor = backgroundColor
    }
    
    func postLocalNotifications(eventTitle:String){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "You've entered a new region"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
       
    }
