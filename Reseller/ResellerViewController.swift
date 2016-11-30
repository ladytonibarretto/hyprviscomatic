//
//  ResellerViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 20/10/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ResellerViewController: BaseViewController {
    
    @IBOutlet var mapView: GMSMapView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    let locationManager = CLLocationManager()

    @IBAction func showSearchBar(_ sender: AnyObject) {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        self.navigationItem.rightBarButtonItem = nil
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    func setNavBar(){
        self.navigationItem.title = "Shops"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ResellerViewController.showSearchBar(_:)))
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        // Locate current location in map
        mapView.isMyLocationEnabled = true
        
        // Add button for current location
        mapView.settings.myLocationButton = true

        loadShopMapMarkers()
    
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadShopMapMarkers(){
        let branches = getShopsLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: 14.530399, longitude: 121.053896, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        view = mapView
        
        var marker = [GMSMarker()]
        
        for (index, branch) in branches.enumerated(){
            marker[index].position = CLLocationCoordinate2D(latitude: branch.latitude, longitude: branch.longitude)
            marker[index].title = branch.name
            marker[index].snippet = branch.address
            marker[index].map = mapView
            marker.append(GMSMarker())
        }
        
        // Creates a marker in the center of the map.
        marker[0].position = CLLocationCoordinate2D(latitude: 14.520445, longitude: 121.053886)
        marker[0].title = "Taguig"
        marker[0].snippet = "BGC"
        marker[0].map = mapView
        
        marker.append(GMSMarker())
    }
    
    func getShopsLocation() -> [Branch]{
//        Call API to get all branches and return json
        
        return []
    }
}

extension ResellerViewController: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}


extension ResellerViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false

        // Do something with the selected place.
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        print("Place lat", place.coordinate.latitude)
        print("Place long", place.coordinate.longitude)
        
        mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        var marker = [GMSMarker()]
        marker[0].position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker[0].title = place.name
        marker[0].snippet = place.formattedAddress
        marker[0].map = mapView
    }
    
    // Error Handler
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        let alertController = UIAlertController(title: "Oops!", message:
            "Unable to connect. Please try again", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
