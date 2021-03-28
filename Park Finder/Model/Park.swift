//
//  Park.swift
//  Park Finder
//
//  Created by Kyle Osterman on 3/27/21.
//

import UIKit
import CoreLocation

struct Park {
    var name: String!
    var coordinates: CLLocationCoordinate2D!
    var isFavorited: Bool!
    var distance: CLLocationDistance!
    var address: String!
}
