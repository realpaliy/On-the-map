//
//  StatusResponse.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/19/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

struct StatusResponse: Codable{
    
    var status: Int
    var error: String
    
}

extension StatusResponse: LocalizedError{
    var errorDescription: String?{
        return error
    }
}
