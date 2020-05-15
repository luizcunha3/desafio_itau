//
//  AgenciaView.swift
//  Desafio Itau
//
//  Created by Luiz Carlos Cunha  on 15/05/20.
//  Copyright © 2020 Luiz Carlos Cunha . All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol AgenciaViewDelegate {
    func showAgencias(agencias: [Agencia])
    func setLoadingTo(_ state: Bool)
}

class AgenciaView: UIViewController {
    
    var viewModel: AgenciaViewModel!
    private let locationManager = CLLocationManager()
    private var loading = false
    private var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = AgenciaViewModel()
        self.viewModel.delegate = self
        self.locationManager.delegate = self
        self.configureMap(location: nil)
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() != .denied {
            self.locationManager.requestLocation()
        } else {
            print("Advise user to change location status")
        }
    }
    
}

extension AgenciaView {
    func configureMapCanvas(location: CLLocation?) {
        var camera = GMSCameraPosition.camera(withLatitude: -12.86, longitude: -51.20, zoom: 2.0)
        if let userLocation = location {
            camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: 16.0)
        }
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView!)
    }
    
    func setUserMarker(location: CLLocation?) {
        if let userLocation = location {
            let userMarker = GMSMarker()
            userMarker.position = userLocation.coordinate
            userMarker.map = mapView!
        }
    }
    
    func configureMap(location: CLLocation?) {
        self.configureMapCanvas(location: location)
        self.setUserMarker(location: location)
        
    }
}

extension AgenciaView: AgenciaViewDelegate {
    
    func setLoadingTo(_ state: Bool) {
        state ? print("Loading") : print("Not Loading")
    }
    
    func showAgencias(agencias: [Agencia]) {
        print("Show Agencias")
    }
}

extension AgenciaView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            print("User denied location")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.configureMap(location: location)
            self.viewModel.ready(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fatal Error")
    }
}



