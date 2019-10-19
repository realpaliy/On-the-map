//
//  UserUpdate.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/18/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

struct UserUpdate: Codable{
    var firstName: String
    var lastName: String

    enum CodingKeys: String, CodingKey{
        
        case firstName = "first_name"
        case lastName = "last_name"
        
    }

}

