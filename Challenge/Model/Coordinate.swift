//
//  Coordinate.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import Foundation

class Coordinate: NSObject, Codable {
    @objc public var latitude: NSDecimalNumber?
    @objc public var longitude: NSDecimalNumber?
    
    @objc public init(latitude: NSDecimalNumber, longitude: NSDecimalNumber) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = NSDecimalNumber(floatLiteral: try values.decode(Double.self, forKey: .latitude))
        longitude = NSDecimalNumber(floatLiteral: try values.decode(Double.self, forKey: .longitude))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude?.doubleValue, forKey: .latitude)
        try container.encode(longitude?.doubleValue, forKey: .longitude)
    }
}
