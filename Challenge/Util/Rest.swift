//
//  Rest.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import Foundation
import Alamofire

class Rest {
    static let baseURL: String = "https://fake-poi-api.mytaxi.com"
    
    static func request<T: Codable>(on endPoint: String, method: HTTPMethod, parameters: Parameters, completion: @escaping (_ response: T?, _ error: Error?) -> Void) {
        Alamofire.request(baseURL + endPoint,
                          method: method,
                          parameters: parameters)
            .responseJSON { response in
                if let error = response.error {
                    completion(nil, error)
                } else {
                    do {
                        if let data = response.data {
                            let responseData = try JSONDecoder().decode(T.self, from: data)
                            completion(responseData, nil)
                        } else {
                            completion(nil, nil)
                        }
                    } catch {
                        completion(nil, error)
                    }
                }
        }
    }
}
