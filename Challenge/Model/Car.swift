//
//  Car.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import Foundation

class Car: NSObject, Codable {
    var id: Int?
    @objc public var coordinate: Coordinate?
    var fleetType: CarType?
    @objc public var heading: NSDecimalNumber?
    
    @objc override public init() {
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case coordinate
        case fleetType
        case heading
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int?.self, forKey: .id)
        coordinate = try values.decode(Coordinate?.self, forKey: .coordinate)
        fleetType = try values.decode(CarType?.self, forKey: .fleetType)
        heading = NSDecimalNumber(floatLiteral: try values.decode(Double.self, forKey: .heading))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(fleetType, forKey: .fleetType)
        try container.encode(heading?.doubleValue, forKey: .heading)
    }
}
