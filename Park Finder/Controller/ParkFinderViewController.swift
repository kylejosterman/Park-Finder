//
//  ParkFinderViewController.swift
//  Park Finder
//
//  Created by Kyle Osterman on 3/27/21.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class ParkFinderViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var mapItems = [MKMapItem()]
    var route: MKRoute!
    lazy var parkArr = [Park]()
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var locationManager = CLLocationManager()
    var currentStatus = CLLocationManager.authorizationStatus()
    var location = UserLocation()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        location.requestLocationAuthorization()
        currentStatus = CLLocationManager.authorizationStatus()
        if (CLLocationManager.authorizationStatus() != .authorizedWhenInUse || CLLocationManager.authorizationStatus() != .authorizedAlways) {
            location.requestLocationAuthorization()
        }
        searchForParks()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc
    func refreshContent(refreshControl: UIRefreshControl) {
        searchForParks()
        parkArr.removeAll()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkTableViewCell", for: indexPath) as! ParkTableViewCell
        cell.parkNameLabel.text = parkArr[indexPath.row].name
        // Rounds to two decimal places
        let distance = String(format: "%.2f", parkArr[indexPath.row].distance)
        cell.distanceLabel.text = distance + " Miles"
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), for: .normal)
        button.sizeToFit()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.tintColor = .black
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        button.tag = indexPath.row
        cell.accessoryView = button
        
        return cell
    }
    
    @objc
    func favoriteTapped(_ sender: Any) {
        print("fav")
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func searchForParks() {
        // Create a request
        let req = MKLocalSearch.Request()
        // Query for park
        req.naturalLanguageQuery = "Park"
        req.region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 1, longitudeDelta: 1))
        req.resultTypes = .pointOfInterest
        // Filter to find only parks and national parks
        let filter = MKPointOfInterestFilter(including: [.park, .nationalPark])
        req.pointOfInterestFilter = filter
        // Start the search
        let search = MKLocalSearch(request:req)
        search.start { response, error in
            guard let response = response else {
                print(error as Any)
                return
            }
            // Add the items to the array
            self.mapItems = response.mapItems
            self.convertArray(mapItems: self.mapItems)
        }
        
    }
    
    func getDistanceFromPark() {
        
    }
    
    // Populates and returns an array full of Parks
    func convertArray(mapItems: Array<MKMapItem>) {
        parkArr.reserveCapacity(25)
        for i in 0...mapItems.count - 1 {
            currentLocation = locationManager.location!
            let distanceInMeters = currentLocation.distance(from: mapItems[i].placemark.location!)
            // Converts meters to miles
            let distance = distanceInMeters * 0.000621371
            let name = mapItems[i].name
            let coordinates = mapItems[i].placemark.coordinate
            parkArr.append(Park(name: name, coordinates: coordinates, isFavorited: false, distance: distance))
        }

        // Sort in descending order
        parkArr = parkArr.sorted(by: { $0.distance < $1.distance })
        
        self.tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// Converts double to string
extension LosslessStringConvertible {
    var string: String { .init(self) }
}
