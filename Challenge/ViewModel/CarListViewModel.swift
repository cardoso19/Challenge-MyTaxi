//
//  CarListViewModel.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class CarListViewModel: NSObject {
    
    //MARK: - Variables
    private var _cars: [Car]?
    private var _filteredCars: [Car]?
    private var _isLoading: Bool = false
    private var _lastUserLocation: CLLocation?
    private var _isTaxiSelected: Bool = true
    private var _isPoolSelected: Bool = true
    private var _requestCompletion: ((_ error: Error?) -> Void)?
    public let rowHeight: CGFloat = 60
    public var isLoading: Bool {
        return _isLoading
    }
    public var carsCount: Int {
        return _filteredCars?.count ?? 0
    }
    @objc public var cars: [Car] {
        return _filteredCars ?? []
    }
    
    //MARK: - CarType
    func getSelectedTypes() -> [CarType] {
        var types: [CarType] = []
        if _isTaxiSelected {
            types.append(.taxi)
        }
        if _isPoolSelected {
            types.append(.pooling)
        }
        return types
    }
    
    func changeTaxiSelection() -> Bool {
        if _isTaxiSelected && !_isPoolSelected {
            return false
        }
        _isTaxiSelected = !_isTaxiSelected
        _filteredCars = filter(cars: _cars ?? [], by: getSelectedTypes())
        _requestCompletion?(nil)
        return true
    }
    
    func changePoolSelection() -> Bool {
        if !_isTaxiSelected && _isPoolSelected { 
            return false
        }
        _isPoolSelected = !_isPoolSelected
        _filteredCars = filter(cars: _cars ?? [], by: getSelectedTypes())
        _requestCompletion?(nil)
        return true
    }
    
    //MARK: - Request
    @objc func requestCarsWith(bottomCoordinate: CLLocationCoordinate2D, topCoordinate: CLLocationCoordinate2D, userLocation: CLLocation?, completion: @escaping (_ error: Error?) -> Void) {
        _requestCompletion = completion
        _lastUserLocation = userLocation
        if !_isLoading {
            let parameters: Parameters = ["p2Lat": bottomCoordinate.latitude,
                                          "p2Lon": bottomCoordinate.longitude,
                                          "p1Lat": topCoordinate.latitude,
                                          "p1Lon": topCoordinate.longitude]
            _isLoading = true
            Rest.request(on: "/",
                         method: .get,
                         parameters: parameters) { (response: PoiList?, error) in
                            self._isLoading = false
                            if let cars = response?.cars {
                                if let userLocation = self._lastUserLocation {
                                    self._cars = self.sort(cars: cars, by: userLocation)
                                } else {
                                    self._cars = cars
                                }
                                self._filteredCars = self.filter(cars: self._cars ?? [], by: self.getSelectedTypes())
                            }
                            completion(error)
            }
        }
    }
    
    @objc func getData(on indexPath: IndexPath) -> DescribedCar? {
        guard let cars = _filteredCars else { return nil }
        guard indexPath.row < cars.count else { return nil }
        let car = cars[indexPath.row]
        let type: String = car.fleetType?.rawValue.capitalized ?? ""
        var distance: String = "? m"
        if let userLocation = _lastUserLocation, let carLocation = createCLLocation(with: car.coordinate) {
            let distanceValue = userLocation.distance(from: carLocation)
            if distanceValue > 1000 {
                distance = String(format: "%.2f km", distanceValue/1000)
            } else {
                distance = String(format: "%.2f m", distanceValue)
            }
        }
        return DescribedCar(type: type,
                            distance: distance)
    }
    
    //MARK: - Util
    func sort(cars: [Car], by userLocation: CLLocation) -> [Car] {
        return cars.sorted(by: { (car1, car2) -> Bool in
            if let car1Location = createCLLocation(with: car1.coordinate), let car2Location = createCLLocation(with: car2.coordinate) {
                return car1Location.distance(from: userLocation) < car2Location.distance(from: userLocation)
            } else {
                return false
            }
        })
    }
    
    func filter(cars: [Car], by types: [CarType]) -> [Car] {
        return cars.filter({ (car) -> Bool in
            guard let type = car.fleetType else { return false }
            for selectedType in types {
                if type == selectedType {
                    return true
                }
            }
            return false
        })
    }
    
    func createCLLocation(with coordinate: Coordinate?) -> CLLocation? {
        guard let latitude = coordinate?.latitude else { return nil }
        guard let longitude = coordinate?.longitude else { return nil }
        return CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    }
    
    //MARK: - Icons
    func getTaxiIcon() -> UIImage? {
        return _isTaxiSelected ? UIImage(named: "taxi-selected") : UIImage(named: "taxi-unselected")
    }
    
    func getPoolIcon() -> UIImage? {
        return _isPoolSelected ? UIImage(named: "pool-selected") : UIImage(named: "pool-unselected")
    }
    
    @objc func getIconWith(car: Car) -> UIImage? {
        guard let type = car.fleetType else { return nil }
        switch type {
        case .taxi:
            return UIImage(named: "taxi")
        case .pooling:
            return UIImage(named: "pool")
        }
    }
}
