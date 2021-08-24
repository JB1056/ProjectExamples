//  Created by QFOUR DEVELOPMENT on 1/10/20.
//  Copyright © 2020 Q-FOUR DEVELOPMENT. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps

// MARK: - ViewControllerWrapper
struct GoogleMapViewControllerWrapper: UIViewControllerRepresentable {
    
    @Binding var lon : Double
    @Binding var lat : Double
    
    typealias UIViewControllerType = GoogleMapViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GoogleMapViewControllerWrapper>) -> GoogleMapViewControllerWrapper.UIViewControllerType {
        return GoogleMapViewController()
    }
    
    func updateUIViewController(_ uiViewController: GoogleMapViewControllerWrapper.UIViewControllerType, context:
        UIViewControllerRepresentableContext<GoogleMapViewControllerWrapper>) {
        //
        uiViewController.lat = self.lat
        uiViewController.lon = self.lon
        uiViewController.update()
    }
}

// MARK: - ViewController
class GoogleMapViewController: UIViewController {
    
    var lat : Double = 0.0
    var lon : Double = 0.0
    var mapView : GMSMapView!
    var camera : GMSCameraPosition!
    
    func update() {
        
        if mapView != nil {
            mapView.removeFromSuperview()
        }
        
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 12.
        camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 18.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 1.198, height: UIScreen.main.bounds.height / 2.05), camera: camera)
        self.view.addSubview(mapView)
        
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.title = "Location"
        marker.snippet = Registration.currentRego
        marker.map = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
