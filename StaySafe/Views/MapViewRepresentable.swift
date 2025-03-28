//
//  MapViewRepresentable.swift
//  StaySafe
//
//  Created by Heet Patel on 28/03/2025.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    var fromLocation: CLLocationCoordinate2D
    var toLocation: CLLocationCoordinate2D
    var positions: [CLLocationCoordinate2D] // Route positions
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        // Set initial region
        let midPoint = CLLocationCoordinate2D(
            latitude: (fromLocation.latitude + toLocation.latitude) / 2,
            longitude: (fromLocation.longitude + toLocation.longitude) / 2
        )
        let region = MKCoordinateRegion(
            center: midPoint,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        mapView.setRegion(region, animated: false)
        
        // Add Annotations
        let fromAnnotation = MKPointAnnotation()
        fromAnnotation.coordinate = fromLocation
        fromAnnotation.title = "Start"
        
        let toAnnotation = MKPointAnnotation()
        toAnnotation.coordinate = toLocation
        toAnnotation.title = "End"
        
        mapView.addAnnotations([fromAnnotation, toAnnotation])
        

        
        let request = MKDirections.Request()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: toLocation))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: fromLocation))
        request.transportType = .any
        
        MKDirections(request: request).calculate { response, error in
            
            if let error = error {
                print("Error calculating directions: \(error)")
                return
            }
        
            
            if let response = response  {
                let polyline = response.routes.first?.polyline
                if let polyline = polyline {
                    mapView.addOverlay(polyline)
                }
            }
        }
        
        if let poslast = positions.last {
            
            let last = MKPointAnnotation()
            last.coordinate = poslast
            last.title = "Last Position"
            mapView.addAnnotation(last)
            
            let route = MKDirections.Request()
            route.destination = MKMapItem(placemark: MKPlacemark(coordinate: toLocation))
            route.source = MKMapItem(placemark: MKPlacemark(coordinate: poslast))
            route.transportType = .any
            
            MKDirections(request: route).calculate { response, error in
                
                if let error = error {
                    print("Error calculating directions: \(error)")
                    return
                }
                
                
                if let response = response  {
                    let polyline = response.routes.first?.polyline
                    if let polyline = polyline {
                        mapView.addOverlay(polyline)
                    }
                }
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Refresh route if needed
//        if !positions.isEmpty {
//            uiView.removeOverlays(uiView.overlays)
//            let polyline = MKPolyline(coordinates: positions, count: positions.count)
//            uiView.addOverlay(polyline)
//        }
    }
}
