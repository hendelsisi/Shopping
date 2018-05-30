
//  LocationManager.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/24/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import CoreLocation
import Foundation

protocol LocationManagerDelegate: NSObjectProtocol {
    func locationMngrDidSucceed()

    func locationMngrDidFail()
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    //sibltone instance

    var locationManager: CLLocationManager?
    weak var delegateMgr: LocationManagerDelegate?

    class func getInstance() -> LocationManager? {
        var sharedLocation: LocationManager? = nil
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            if sharedLocation == nil {
                sharedLocation = LocationManager()
            }
        }
        return sharedLocation
    }

    //location request and store
//    func isAppStoredUserLocation() -> Bool {
//       // return UserDefaults.standard.object(forKey: USER_DEFAULTS_LONG_KEY) != nil
//    }

    func getUserLocation() {
        locationManager?.startUpdatingLocation()
    }

    func isGetUserLocationAllowed() -> Bool {
        return CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
    }

    func handleLocationRequest(_ viewCont: CouponDetailViewController?) {
        let isLocationEnabled: Bool = isGetUserLocationAllowed()
        if isLocationEnabled {
            getUserLocation()
        } else {
         //   Utility.getInstance()?.alertMsg(viewCont, andMsg: NSLocalizedString("location msg", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), andTitle: "")
        }
    }

    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    
    }

// MARK::store user location at user defaults
    func store(_ longi: Double, userLogs latit: Double) {
//        UserDefaults.standard.set(longi, forKey: USER_DEFAULTS_LONG_KEY)
//        UserDefaults.standard.set(latit, forKey: USER_DEFAULTS_LATIT_KEY)
    }

// MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("didFailWithError: \(error ?? "")")
        delegateMgr?.locationMngrDidFail()
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateTo newLocation: CLLocation, from oldLocation: CLLocation) {
//        let currentLocation: CLLocation? = newLocation
//        if currentLocation != nil {
//            let longi: Double? = currentLocation?.coordinate.longitude
//            let latit: Double? = currentLocation?.coordinate.latitude
//          //  store(longi, userLogs: latit)
//        }
//        locationManager?.stopUpdatingLocation()
//        delegateMgr?.locationMngrDidSucceed()
//    }
}
