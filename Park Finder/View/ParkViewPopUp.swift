//
//  ParkViewPopUp.swift
//  Park Finder
//
//  Created by Kyle Osterman on 3/27/21.
//

import UIKit
import CoreLocation
import MapKit

// Doesn't work, need to use CoreData to get the required data from the ParkFinderViewController parkArr but there is not enough time
// User Defaults doesn't work well with custom objects (just passes nil)
// Was planning on displaying more information about the park as well as a button to open in maps
class ParkViewPopUp: UIView {
    
    var selectedPark = UserDefaults()
    var currentLocation = CLLocation()
    
//MARK: - Animations
    @objc
    fileprivate func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    @objc
    func exitButtonAction(_ sender: UIButton!) {
        animateOut()
    }
    
    // Doesn't work, need to use CoreData to get the required data from the ParkFinderViewController aka not enough time
    // User Defaults doesn't work well with custom objects (just passes nil)
    @objc
    func openMapDirections() {
//        let mapItem = MKMapItem(placemark: .init(coordinate: park?.coordinates ?? CLLocationCoordinate2D(latitude: 35.7847, longitude: 78.6821)))
        OpenMapDirections.present(in: self, sourceView: openMapsButton)
        print(currentLocation)

        NotificationCenter.default.post(name: .didReceivePark, object: nil)
    }
    
//MARK: - Components Setup
    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 40)))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Park Information"
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()

    fileprivate let openMapsButton: UIButton = {
        let button = UIButton()
        Utility.styleFilledButton(button)
        button.backgroundColor = Color.appBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open in Maps", for: .normal)
        button.addTarget(self, action: #selector(openMapDirections), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        return button
    }()
    
    fileprivate let exitButton: UIButton = {
        let button = UIButton()
        //x.circle.fill
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitButtonAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 20
        v.backgroundColor = .white
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        
        // Main container
        self.addSubview(container)
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35).isActive = true
        
        // Title label
        self.container.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 10.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.container.centerXAnchor).isActive = true
        
        // Exit Button
        container.addSubview(exitButton)
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exitButtonAction)))
        exitButton.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 15).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -10).isActive = true

        // Open Maps Button
        container.addSubview(openMapsButton)
        openMapsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMapDirections)))
        openMapsButton.centerXAnchor.constraint(equalTo: self.container.centerXAnchor).isActive = true
        openMapsButton.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -30.0).isActive = true
        openMapsButton.widthAnchor.constraint(equalToConstant: 225).isActive = true
        openMapsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
