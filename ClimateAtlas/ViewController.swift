//
//  ViewController.swift
//  ClimateAtlas
//
//  Created by Jacob Hausmann on 5/8/19.
//  Copyright © 2019 Jacob Hausmann. All rights reserved.
//

import Cocoa
import MapKit

let ANNOTATION_IDENTIFIER = "Annotation"

class ViewController: NSViewController {
    // MARK: - Properties
    let searchRequest:MKLocalSearch.Request = MKLocalSearch.Request()
    var annotation:PinAnnotation?

    // MARK: - Outlets
    @IBOutlet var searchBarTextField: NSTextField!
    @IBOutlet var mapView: MKMapView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Actions

    @IBAction func searchBarAction(_ sender: Any) {
        print(searchBarTextField.stringValue)
        searchRequest.naturalLanguageQuery = searchBarTextField.stringValue
        searchRequest.region = mapView.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard error == nil else {
                print("Error")
                return
            }
            guard let placemark = response?.mapItems[0].placemark else {
                print("No placemark")
                return
            }
            guard let title = placemark.title else {return}
            //            guard let subtitle = placemark.subtitle? else {return}
            let coords = placemark.coordinate

            if self.annotation != nil {
                self.mapView.removeAnnotation(self.annotation!)
                self.annotation = nil
            }

            self.annotation = PinAnnotation(coordinate: coords, title: title, subtitle: "")
            self.mapView.addAnnotation(self.annotation!)
            let region = MKCoordinateRegion(center: coords, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    // MARK: - Methods

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

class PinAnnotation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate:CLLocationCoordinate2D, title: String, subtitle:String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }

    class func createViewAnnotationForMap(mapView:MKMapView, annotation:MKAnnotation) -> MKAnnotationView {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ANNOTATION_IDENTIFIER){
            return annotationView
        }else{
            //            let returnedAnnotationView:MKAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: ANNOTATION_IDENTIFIER)
            //            let image = NSImage(size: NSSize(width: 25, height: 25))
            //            image.
            //            returnedAnnotationView.image = NSImage(named: "dot")
            let returnedAnnotationView:MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier:"PinAnnotation")
            returnedAnnotationView.pinTintColor = NSColor.red
            returnedAnnotationView.animatesDrop = true
            returnedAnnotationView.canShowCallout = true
            return returnedAnnotationView

        }
    }
}
