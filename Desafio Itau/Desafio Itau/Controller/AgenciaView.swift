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
    
    @IBOutlet weak var agencyInfoView: UIView!
    @IBOutlet weak var agencyAddress: UILabel!
    @IBOutlet weak var agencyName: UILabel!
    @IBOutlet weak var agencyOpeningHours: UILabel!
    
    
    
    var viewModel: AgenciaViewModel!
    private let locationManager = CLLocationManager()
    private var loading = false
    private var userLastLocation: CLLocation?
    private var clickedMarker: GMSMarker? = nil
    @IBOutlet weak var mapView: GMSMapView!
    private var markers: [GMSMarker] = []
    private var agencies: [Agencia] = []
    private var infoView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMap(location: nil)
        self.viewModel = AgenciaViewModel()
        self.viewModel.delegate = self
        self.locationManager.delegate = self
        
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
        var camera = GMSCameraPosition.camera(withLatitude: ConstantsHelper.DEFAULT_LATITUDE, longitude: ConstantsHelper.DEFAULT_LONGITUDE, zoom: ConstantsHelper.DEFAULT_ZOOM)
        if let userLocation = location {
            camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: 16.0)
        }
        
        mapView.camera = camera
    }
    
    func setUserMarker(location: CLLocation?) {
        if let userLocation = location {
            let userMarker = GMSMarker()
            userMarker.position = userLocation.coordinate
            userMarker.map = mapView!
        }
    }
    
    func createAgencyMarker(agency: Agencia) -> GMSMarker? {
        if let agencyCoordinate = agency.location {
            let agencyMarker = GMSMarker()
            agencyMarker.position = agencyCoordinate
            agencyMarker.title = agency.nome
            agencyMarker.snippet = agency.endereco! + "\n" + (agency.stringHorarioDeFuncionamento ?? "")
            agencyMarker.icon = UIImage(named: "itau")
            agencyMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            agencyMarker.tracksViewChanges = true
            agencyMarker.map = self.mapView!
            return agencyMarker
        } else {
            return nil
        }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func fitMapToMarkers(location: CLLocation?, markers: [GMSMarker]) {
        var bounds = GMSCoordinateBounds()
        if let userLocation = location {
            bounds = bounds.includingCoordinate(userLocation.coordinate)
        }
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        let updateMapView = GMSCameraUpdate.fit(bounds, withPadding: 30)
        self.mapView?.animate(with: updateMapView)
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
        var markers: [GMSMarker] = []
        for agency in agencias {
            if let marker = self.createAgencyMarker(agency: agency) {
                markers.append(marker)
            }
        }
        self.markers = markers
        self.agencies = agencias
        self.fitMapToMarkers(location: self.userLastLocation, markers: markers)
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
            self.userLastLocation = location
            self.configureMap(location: location)
            self.viewModel.ready(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fatal Error")
    }
    
    
}



