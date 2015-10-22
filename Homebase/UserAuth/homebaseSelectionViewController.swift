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


class homebaseSelectionViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationServices()
        setupMapView()
        
    }

    func setupLocationServices(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            displayBasicAlert("Error", error: "Please turn on location services to choose or create a homebase", buttonText: "OK")
        }
    }
    
    //automatically called when location changes
    // http://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = manager.location
        print("locations = \(userLocation?.coordinate.latitude) \(userLocation?.coordinate.longitude)")
        
        let regionRadius: CLLocationDistance = 200

        centerMapOnLocation(userLocation!, regionRadius: regionRadius)
        self.locationManager.stopUpdatingLocation()

    }
    
    func setupMapView(){
        self.mapView.showsUserLocation = true
        self.mapView.showsCompass = true
        self.mapView.showsBuildings = true
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var homebaseField: UITextField!

    @IBAction func joinHomeBase(sender: AnyObject) {
        
        // homebase cant be empty
        if(homebaseField.text == ""
            || homebaseField.text?.containsString(".") == true
            || homebaseField.text?.containsString("#") == true
            || homebaseField.text?.containsString("$") == true
            || homebaseField.text?.containsString("[") == true
            || homebaseField.text?.containsString("]") == true
            ) {
                displayBasicAlert("Error", error: "Invalid Character", buttonText: "OK")
                return
        }
        
        
        let user = PFUser.currentUser()!
        user["homebase"] = homebaseField.text
        user.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                let titleText = "Welcome to HomeBase!"
                var errorText = "Please Verify Your Email"
                let alertView = UIAlertController(title: titleText,
                    message: errorText, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "OK",
                    style: .Default,
                    handler: { (alert: UIAlertAction!) in
                        self.performSegueWithIdentifier("finishSignup", sender: nil)
                    }
                )
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                
            } else {
                // There was a problem, check error.description
                self.displayBasicAlert("Error", error: (error?.description)!, buttonText: "Try Again")
                return
            }
        }

        
        
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
