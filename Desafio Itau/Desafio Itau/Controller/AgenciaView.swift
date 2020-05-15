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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = AgenciaViewModel()
        self.viewModel.delegate = self
        self.locationManager.delegate = self
        self.configureMap()
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}

extension AgenciaView {
    func configureMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
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
        } else {
            self.locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.viewModel.ready(location: location)
        }
    }
}



