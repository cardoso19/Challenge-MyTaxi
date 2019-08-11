//
//  DescribedCar.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import Foundation

class DescribedCar: NSObject {
    var type: String
    var distance: String
    
    init(type: String, distance: String) {
        self.type = type
        self.distance = distance
    }
}
