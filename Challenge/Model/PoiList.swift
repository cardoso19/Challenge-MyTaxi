//
//  PoiList.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import Foundation

class PoiList: NSObject, Codable {
    var cars: [Car]?
    
    enum CodingKeys: String, CodingKey {
        case cars = "poiList"
    }
}
