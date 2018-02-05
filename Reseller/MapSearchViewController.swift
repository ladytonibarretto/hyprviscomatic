//
//  MapSearchViewController.swift
//  Reseller
//
//  Created by Lady Barretto on 10/11/2016.
//  Copyright © 2016 Lady Toni Barretto. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class MapSearchViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    
    var resultsViewController: GMSAutocompleteResultsViewController!
    var searchController = UISearchController(searchResultsController: nil)
    var latitude: Double?
    var longitude: Double?
    var marker = GMSMarker()
    let locationManager = CLLocationManager()
    var newAddress: String = ""
    var addBtn = UIButton()
    var isNewAccount: Bool?
    var button: UIButton?
    var isFirstLoad: Bool?
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    // Data from Add Branch Controller
    var branchName: String?
    var branchAddress: String?
    var branchContactNum: String?

    var storeTmpImg1 : UIImageView?
    var storeTmpImg2 : UIImageView?
    var storeTmpImg3 : UIImageView?
    var permitTmpImg1 : UIImageView?
    var permitTmpImg2 : UIImageView?
    var permitTmpImg3 : UIImageView?
    
    @IBOutlet weak var addLocBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        // Locate current location in map
        mapView.isMyLocationEnabled = true
        
        // Add button for current location
        mapView.settings.myLocationButton = true
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        // manually set camera
        mapView.camera = GMSCameraPosition.camera(withLatitude: 14.556484999999995, longitude: 121.0537992, zoom: 10)
        
        showSearchBar()
        
        button = UIButton(frame: CGRect(x: view.frame.midX - 90, y: view.frame.maxY - 80 , width: 180, height: 50))
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.searchController.view.removeFromSuperview()
    self.resultsViewController.view.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        showSearchBar()
        self.searchController.isActive = false
        
        let token: String
        
        // load branches here
        if ad.token == nil {
            token = ""
        } else {
            token = ad.token!
        }
        
        getBranches(token: token, validationCompleted: { (branches) -> Void in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.messageFrame.isUserInteractionEnabled = true
                self.messageFrame.window?.isUserInteractionEnabled = true
                self.messageFrame.removeFromSuperview()
                self.strLabel.isEnabled = false
                self.loadAllBranches(branches: branches)
                self.view.isUserInteractionEnabled = true
                
            }
        })
    }
    
    func showAddButton() {
        self.button?.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.button?.setTitle("Add Location", for: .normal)
        self.button?.titleLabel?.textColor = UIColor(red: 0.902, green: 0.4941, blue: 0.0275, alpha: 1.0)
        self.button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.button?.addTarget(self, action: #selector(addNewLocation), for: .touchUpInside)
        view.addSubview(self.button!)
    }

    func addNewLocation() {
        if newAddress.isEmpty || newAddress == " " {
            let alertController = UIAlertController(title: "Warning!", message:
                "Address is required. Please search your branch address", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {

            self.performSegue(withIdentifier: "pushToAddNewAddress", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddBranchViewController{
            destination.locationAddress = self.newAddress
            destination.latitude = self.latitude
            destination.longitude = self.longitude
            destination.isNewAccount = self.isNewAccount!
            destination.tempBranchName = self.branchName!
            destination.tempBranchAddress = self.branchAddress!
            destination.tempBranchPhone = self.branchContactNum!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSearchBar() {
        
        isFirstLoad = true
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        
        searchController.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController.searchBar.sizeToFit()
        searchController.searchBar.isUserInteractionEnabled = true
        self.navigationItem.titleView = searchController.searchBar
        
        
        // Prevent the navigation bar from being hidden when searching.
        searchController.hidesNavigationBarDuringPresentation = false

        self.definesPresentationContext = true

    }
    
    func loadAddressMarker(lat: Double, long: Double, address: String, name: String){
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        view = mapView
        
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = name
        marker.snippet = address
        marker.map = mapView
        marker.isDraggable = true
    }
    
    func loadAllBranches(branches: [JSON]){
        for branch in branches{
            let branchMarker = GMSMarker()
            let image = UIImage(named: "asset_map_marker")
            let markerView = UIImageView(image: image)
            markerView.tintColor = .red
            markerView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            branchMarker.title = branch["name"].stringValue
            branchMarker.iconView = markerView
            branchMarker.snippet = branch["address"].stringValue
            branchMarker.position = CLLocationCoordinate2D(latitude: Double(branch["lat"].stringValue)!, longitude: Double(branch["lng"].stringValue)!)
            branchMarker.map = mapView
            branchMarker.isDraggable = true
        }
    }
}

extension MapSearchViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var point: CGPoint = self.mapView.projection.point(for: marker.position)
        point.y -= 100
        mapView.animate(toLocation: self.mapView.projection.coordinate(for: point))
        mapView.selectedMarker = marker
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // Get address based on new lat long
        reverseGeocodeCoordinate(coordinate: marker.position)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                // 3
                var addressResult = String()
                let lines = address.lines as [String]!
                
                // Construct Address
                for i in lines!{
                    addressResult = addressResult + " " + i
                }
                
                if ad.token != nil || self.isNewAccount != nil {
                    self.navigationItem.rightBarButtonItem = self.addLocBtn

                }
                self.newAddress = addressResult.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                self.searchController.searchBar.placeholder = self.newAddress
                self.latitude = address.coordinate.latitude
                self.longitude = address.coordinate.longitude
                
                // 4
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

extension MapSearchViewController: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let alertController = UIAlertController(title: "Hey!", message:
            "Didupdatelocationnnnn", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)

        if let location = locations.first{
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.map = mapView
            marker.isDraggable = true
            locationManager.stopUpdatingLocation()
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager,
                                 didFailWithError error: Error) {
        print("Error: ", error)
    }
}

extension MapSearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        self.searchController.isActive = false
        
        let addressView = UIView()
        self.view.addSubview(addressView)
        
        let addressLabel = UILabel()
        addressLabel.text = "Temporary"
        addressView.addSubview(addressLabel)
        
        let viewsDictionary = ["addressView":addressView]
        
        let view1_constraint_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[addressView(0)]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: viewsDictionary)
        let view1_constraint_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[addressView(0)]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        addressView.addConstraints(view1_constraint_H)
        addressView.addConstraints(view1_constraint_V)
        
        loadAddressMarker(lat: place.coordinate.latitude, long: place.coordinate.longitude, address: place.formattedAddress!, name: place.name)
        self.newAddress = place.formattedAddress!
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        self.navigationItem.rightBarButtonItem?.isEnabled = true

        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

