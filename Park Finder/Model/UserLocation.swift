//
//  UserLocation.swift
//  Park Finder
//
//  Created by Kyle Osterman on 3/27/21.
//

import UIKit
import CoreLocation

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?

    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let currentStatus = CLLocationManager.authorizationStatus()

        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }

        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    public func getCurrentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
    
    public func transitionUserToSettings() -> UIAlertController {
        let alertController = UIAlertController (title: "Location Needed", message: "After Five needs your location in order to use this function. Tap the Settings button below and enable location.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .cancel) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Not Now", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        return alertController
    }
}
