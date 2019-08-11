//
//  CarListViewModelTests.swift
//  ChallengeTests
//
//  Created by Matheus Cardoso kuhn on 07/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Challenge

class CarListViewModelTests: XCTestCase {

    var viewModel: CarListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CarListViewModel()
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testIsLoading() {
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testCarsCount() {
        XCTAssertEqual(viewModel.carsCount, 0)
    }
    
    func testCars() {
        XCTAssertEqual(viewModel.cars.count, 0)
    }
    
    func testGetSelectedTypes() {
        XCTAssertEqual(viewModel.getSelectedTypes().count, 2)
    }
    
    func testGetSelectedTypesTaxi() {
        _ = viewModel.changeTaxiSelection()
        XCTAssertEqual(viewModel.getSelectedTypes().first, .pooling)
    }
    
    func testGetSelectedTypesPool() {
        _ = viewModel.changePoolSelection()
        XCTAssertEqual(viewModel.getSelectedTypes().first, .taxi)
    }
    
    func testChangeBothSelection() {
        XCTAssertTrue(viewModel.changeTaxiSelection())
        XCTAssertFalse(viewModel.changePoolSelection())
    }
    
    func testChangeBothSelectionInverse() {
        XCTAssertTrue(viewModel.changePoolSelection())
        XCTAssertFalse(viewModel.changeTaxiSelection())
    }
    
    func testRequestCars() {
        let topCoordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        let bottomCoordinate = CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0)
        let ex = expectation(description: "Expecting server response")
        viewModel.requestCarsWith(bottomCoordinate: topCoordinate,
                                  topCoordinate: bottomCoordinate,
                                  userLocation: nil) { (error) in
                                    XCTAssertNil(error)
                                    ex.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            guard let error = error else { return }
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func testGetData() {
        let topCoordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        let bottomCoordinate = CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0)
        let ex = expectation(description: "Expecting server response")
        viewModel.requestCarsWith(bottomCoordinate: topCoordinate,
                                  topCoordinate: bottomCoordinate,
                                  userLocation: nil) { (error) in
                                    XCTAssertNotNil(self.viewModel.getData(on: IndexPath(row: 0, section: 0)))
                                    ex.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            guard let error = error else { return }
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func testGetDataNil() {
        XCTAssertNil(viewModel.getData(on: IndexPath(row: 0, section: 0)))
    }
    
    func testSortCars() {
        let userLocation = CLLocation(latitude: 1.0, longitude: 1.0)
        let car1 = Car()
        let car2 = Car()
        car1.coordinate = Coordinate(latitude: 1.1, longitude: 1.1)
        car2.coordinate = Coordinate(latitude: 1.0, longitude: 1.0)
        let sortedCars = viewModel.sort(cars: [car1, car2], by: userLocation)
        XCTAssertEqual(sortedCars.first, car2)
    }
    
    func testSortCars2() {
        let userLocation = CLLocation(latitude: 1.0, longitude: 1.0)
        let car1 = Car()
        let car2 = Car()
        car1.coordinate = Coordinate(latitude: 1.1, longitude: 1.1)
        car2.coordinate = Coordinate(latitude: 1.2, longitude: 1.2)
        let sortedCars = viewModel.sort(cars: [car1, car2], by: userLocation)
        XCTAssertEqual(sortedCars.first, car1)
    }
    
    func testFilterBoth() {
        let car1 = Car()
        let car2 = Car()
        car1.fleetType = .taxi
        car2.fleetType = .pooling
        let filteredCars = viewModel.filter(cars: [car1, car2], by: [.taxi, .pooling])
        XCTAssertEqual(filteredCars.count, 2)
    }
    
    func testFilterTaxi() {
        let car1 = Car()
        let car2 = Car()
        car1.fleetType = .taxi
        car2.fleetType = .pooling
        let filteredCars = viewModel.filter(cars: [car1, car2], by: [.taxi])
        XCTAssertEqual(filteredCars.count, 1)
    }
    
    func testFilterPool() {
        let car1 = Car()
        let car2 = Car()
        car1.fleetType = .taxi
        car2.fleetType = .pooling
        let filteredCars = viewModel.filter(cars: [car1, car2], by: [.pooling])
        XCTAssertEqual(filteredCars.count, 1)
    }
    
    func testCreateCLLocation() {
        let coordinate = Coordinate(latitude: 1.0, longitude: 2.0)
        let location = viewModel.createCLLocation(with: coordinate)
        XCTAssertNotNil(location)
        XCTAssertEqual(coordinate.latitude, 1.0)
        XCTAssertEqual(coordinate.longitude, 2.0)
    }
    
    func testGetTaxiIconSelected() {
        XCTAssertEqual(viewModel.getTaxiIcon(), UIImage(named: "taxi-selected"))
    }
    
    func testGetTaxiIconUnselected() {
        _ = viewModel.changeTaxiSelection()
        XCTAssertEqual(viewModel.getTaxiIcon(), UIImage(named: "taxi-unselected"))
    }
    
    func testGetPoolIconSelected() {
        XCTAssertEqual(viewModel.getPoolIcon(), UIImage(named: "pool-selected"))
    }
    
    func testGetPoolIconUnselected() {
        _ = viewModel.changePoolSelection()
        XCTAssertEqual(viewModel.getPoolIcon(), UIImage(named: "pool-unselected"))
    }
    
    func testGetIconWithCarTaxi() {
        let car = Car()
        car.fleetType = .taxi
        XCTAssertEqual(viewModel.getIconWith(car: car), UIImage(named: "taxi"))
    }
    
    func testGetIconWithCarPool() {
        let car = Car()
        car.fleetType = .pooling
        XCTAssertEqual(viewModel.getIconWith(car: car), UIImage(named: "pool"))
    }
    
    func testGetIconWithCarNil() {
        let car = Car()
        XCTAssertEqual(viewModel.getIconWith(car: car), nil)
    }
}
