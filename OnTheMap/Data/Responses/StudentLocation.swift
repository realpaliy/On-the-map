//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

struct StudentLocation: Codable{
    
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey{
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
    
}
