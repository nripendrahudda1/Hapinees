//
//  LocationManager.swift
//  Travelory
//
//  Created by Nripendra Kumar  on 20/12/2023.
//  Copyright © 2023 Travelory. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationErrorType: String {
    case denied = "Locations are turned off. Please turn it on in Settings"
    case restricted = "Locations are restricted"
    case notDetermined = "Locations are not determined yet"
    case unknown = "Unknown Error occurred"
}

class LocationError:Error {
    var error: LocationErrorType
    
    init(error: LocationErrorType) {
        self.error = error
    }
}

protocol Locatable: AnyObject {
    func locationDidUpdate(location: CLLocation)
    //func headingDidUpdate(heading: CLHeading)
}

class LocationManagerService: NSObject {
    
    private var locationManager: CLLocationManager? 
    var locationAccuracy = kCLLocationAccuracyBest
    
    typealias LocationClosure = ((_ location: CLLocation?, _ error: LocationError?)->Void)
    
    private var completion: LocationClosure?
    private var enableUpdatingLocation: Bool = true
    weak var delegate: Locatable? = nil
    
    static let shared: LocationManagerService = {
        let instance = LocationManagerService()
        return instance
    }()
    
    private override init() {}
    
    //MARK:- Private Methods
     func setupLocationManager() {
        //Setting of location manager
        locationManager = nil
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = locationAccuracy
        locationManager?.delegate = self
//        locationManager?.distanceFilter = 10 
        locationManager?.showsBackgroundLocationIndicator = true
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestWhenInUseAuthorization()
//        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.startUpdatingHeading()

    }
    
    private func requestForLocation() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager?.authorizationStatus ?? .notDetermined
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus
        {
        case .denied:
            let deniedError = LocationError.init(error: LocationErrorType.denied)
            self.completion?(nil, deniedError)
            break
        case .restricted:
            let restrictedError = LocationError.init(error: LocationErrorType.restricted)
            self.completion?(nil,restrictedError)
            break
        case .authorizedAlways,.authorizedWhenInUse,.notDetermined:
            self.setupLocationManager()
            break
        default:
            break;
        }
    }
    
    var isLocationServiceEnabled: Bool {
        let authorizationStatus: CLAuthorizationStatus
           if #available(iOS 14, *) {
               authorizationStatus = locationManager?.authorizationStatus ?? .notDetermined
           } else {
               authorizationStatus = CLLocationManager.authorizationStatus()
           }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    func getLocation(enableUpdating: Bool = true , completionHandler:@escaping LocationClosure) {
        locationManager?.startUpdatingLocation()
        locationManager?.startUpdatingHeading()
        completion = completionHandler
        enableUpdatingLocation = enableUpdating
        requestForLocation()
    }
}


extension LocationManagerService: CLLocationManagerDelegate {
    
    //MARK: - CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            self.delegate?.locationDidUpdate(location: location)
            
            let locationAge = -(location.timestamp.timeIntervalSinceNow)
            if (locationAge > 1.0) {
              
                return
            }
            
            if location.horizontalAccuracy < 0 {
                self.locationManager?.stopUpdatingLocation()
                self.locationManager?.startUpdatingLocation()
                return
                
            }
            if !self.enableUpdatingLocation {
                self.locationManager?.stopUpdatingLocation()
            }
            
            self.completion?(location, nil)
            if #available(iOS 15.0, *) {

                let isLocationSimulated = location.sourceInformation?.isSimulatedBySoftware ?? false
                let isProducedByAccessory = location.sourceInformation?.isProducedByAccessory ?? false
                
                if isLocationSimulated == true || isProducedByAccessory == true {
                    
                }
            }

        }
    }
       
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .authorizedWhenInUse,.authorizedAlways:
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.startUpdatingHeading()
            
        case .denied:
            let deniedError = LocationError.init(error: LocationErrorType.denied)
            self.completion?(nil,deniedError)
            
        case .restricted:
            let restrictedError = LocationError.init(error: LocationErrorType.restricted)
            self.completion?(nil,restrictedError)
            
        case .notDetermined:
            self.locationManager?.requestLocation()
            
        @unknown default:
            let unknownError = LocationError.init(error: LocationErrorType.unknown)
            self.completion?(nil,unknownError)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completion?(nil,error as? LocationError)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //self.delegate?.headingDidUpdate(with: newHeading)
    }
}
