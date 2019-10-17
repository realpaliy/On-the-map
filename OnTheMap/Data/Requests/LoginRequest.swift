//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

struct LoginRequest: Codable{
    let udacity: LoginCredentials
}

struct LoginCredentials: Codable{
    let username: String
    let password: String
}
