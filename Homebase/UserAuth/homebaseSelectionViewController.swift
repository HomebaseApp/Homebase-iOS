//
//  homebaseSelectionViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import MapKit
import Parse
import Bolts


class homebaseSelectionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLocationServices()
        verifyAuthorized()

    }

    func setupLocationServices(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        
        while CLLocationManager.authorizationStatus() == .NotDetermined {}
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func setupMapView(){
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.showsCompass = true
        self.mapView.showsBuildings = true
    }
    
    func verifyAuthorized() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined:
                print("Not yet authorized")
                setupLocationServices()
                return false
            case .Restricted, .Denied:
                print("No access")
                self.displayBasicAlert("Error", error: "Please turn on location services to create a homebase", buttonText: "OK")
                return false
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Access")
                setupLocationServices()
                
                if ((locationManager.location) != nil) {
                    centerMapOnLocation(locationManager.location!, regionRadius: CLLocationDistance(100))
                }
                queryHomebasesInView()
                return true
            }
        } else {
            self.displayBasicAlert("Error", error: "Please turn on location services to create a homebase", buttonText: "OK")
            return false
        }
    }
    
    @IBAction func backToCurrentLocation(sender: AnyObject) {
        if ((locationManager.location) != nil) {
            centerMapOnLocation(locationManager.location!, regionRadius: CLLocationDistance(100))
        }
    }
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func queryHomebasesInView(){
        let mapCenterLongitude = self.mapView.region.center.longitude
        let mapWestBound = mapCenterLongitude - (self.mapView.region.span.longitudeDelta/2)
        let mapEastBound = mapCenterLongitude + (self.mapView.region.span.longitudeDelta/2)
        
        let mapCenterLatitude = self.mapView.region.center.latitude
        let mapNorthBound = mapCenterLatitude + (self.mapView.region.span.latitudeDelta/2)
        let mapSouthBound = mapCenterLatitude - (self.mapView.region.span.latitudeDelta/2)
        
        // remove annotations out of view
        // http://stackoverflow.com/questions/10865088/how-do-i-remove-all-annotations-from-mkmapview-except-the-user-location-annotati
        let annotationsToRemove = mapView.annotations.filter {
            $0.coordinate.latitude <= mapSouthBound
            || $0.coordinate.latitude >= mapNorthBound
            || $0.coordinate.longitude <= mapWestBound
            || $0.coordinate.longitude >= mapEastBound
        }
        self.mapView.removeAnnotations( annotationsToRemove )
        
        let mapSW = PFGeoPoint(
            latitude: checkValidCoordinate(mapSouthBound),
            longitude:checkValidCoordinate(mapWestBound))
        let mapNE = PFGeoPoint(
            latitude: checkValidCoordinate(mapNorthBound),
            longitude: checkValidCoordinate(mapEastBound))
        
        // Create a query for places
        let query = PFQuery(className:"Homebase")
        // Interested in locations near user.
        query.whereKey("location", withinGeoBoxFromSouthwest:mapSW, toNortheast:mapNE)
        // Limit what could be a lot of points.
        query.limit = 30
        // Final list of objects
        let Homebases = query.findObjectsInBackgroundWithBlock({
            (Homebases: [PFObject]?,error: NSError?) -> Void in
            if Homebases != nil {
                self.mapView.removeAnnotations(self.mapView.annotations)
                for base in Homebases! {
                    // do stuff
                    let baseAnnotation: HomebaseAnnotation = HomebaseAnnotation(homebase: base as! Homebase)
                    
                    self.mapView.addAnnotation(baseAnnotation)
                }
            }
        })
    }
    
    func checkValidCoordinate(coordinate:Double) -> Double{
        var fixedCoordinate: Double = coordinate
        if coordinate >= 180 {
            fixedCoordinate = 180
        } else if coordinate <= -180 {
            fixedCoordinate = -180
        }
        return fixedCoordinate
    }
    
    // http://stackoverflow.com/questions/33123724/swift-adding-a-button-to-my-mkpointannotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? { // sets up annotation view to add the button
        if annotation.title! != "Current Location" {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("homebase")
            if annotationView == nil{
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "homebase")
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            
            annotationView?.leftCalloutAccessoryView = nil
            annotationView?.rightCalloutAccessoryView = createHomebaseAnnotationButton("addUser")
            
            return annotationView
        } else { // for current location use usual icon
            let currentLoc = self.mapView.viewForAnnotation(self.mapView.userLocation)
            currentLoc?.canShowCallout = false
            return currentLoc
        }

    }
    
    func createHomebaseAnnotationButton(image: String) -> UIButton{
        let homebaseButton = UIButton(type: UIButtonType.Custom)
        let buttonImage = UIImage(named: image)
        if buttonImage != nil {
            homebaseButton.setImage(buttonImage, forState: UIControlState.Normal)
            homebaseButton.frame = CGRectMake(0, 0, buttonImage!.size.width, buttonImage!.size.height)
        }
        
        return homebaseButton
    }
    
    // MARK: - join Homebase
    // Join Homebase button
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.Custom {
            mapView.deselectAnnotation(view.annotation, animated: false)
            
            let newHomebase = (view.annotation as! HomebaseAnnotation).homebase
            
            // add user to homebase
            newHomebase.users.addObject( HomebaseUser.currentUser()!)
            
            // add homebase to user
            HomebaseUser.currentUser()?.homebase = newHomebase
            HomebaseUser.currentUser()?.saveInBackground()
            
            //HomebaseUser.currentUser()?.relationForKey("homebase").addObject((view.annotation as! HomebaseAnnotation).homebase)
            self.performSegueWithIdentifier("finishSignup", sender: self)
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        queryHomebasesInView()
    }
    
    @IBAction func createNewHomebase(sender: AnyObject) {
        //start the object to hold info
        

        // http://stackoverflow.com/questions/26567413/how-to-get-input-value-from-textfield-in-alert
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Create New Homebase", message: "Enter a name", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "1 Infinite Loop 🍎"
        })
        
        // Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: {
            (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        //3. Grab the value from the text field, check if it is valid
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: {
            (action) -> Void in
            let homebaseField = alert.textFields![0] as UITextField
            if(homebaseField.text == ""
                || homebaseField.text?.containsString(".") == true
                || homebaseField.text?.containsString("#") == true
                || homebaseField.text?.containsString("$") == true
                || homebaseField.text?.containsString("[") == true
                || homebaseField.text?.containsString("]") == true
                )
            {
                alert.title = "Invalid Characters"
                self.presentViewController(alert, animated: true, completion: nil)
                return
            } else {
                print( homebaseField.text!)
                
                // create the homebase
                let homebase = Homebase(name: homebaseField.text!,
                    location: PFGeoPoint(location: self.locationManager.location),
                    owner: user()!)
                
                // save to server
                homebase.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        user()!.homebase = homebase
                        user()!.saveInBackground()
                        self.performSegueWithIdentifier("finishSignup", sender: self)
                        print("Success")
                    } else {
                        // There was a problem, check error.description
                        print(error?.description)
                    }
                }
            }
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
