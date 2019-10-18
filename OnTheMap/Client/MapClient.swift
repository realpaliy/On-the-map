//
//  MapClient.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

class MapClient {
    
    struct Auth{
        static var accountId = ""
        static var sessionId = ""
    }
    
    enum Endpoints{
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getStudentLocation
        case postStudentLocation
        case putStudentLocation(String)
        
        var stringValue: String{
            switch self {
            case .login: return Endpoints.base + "/session"
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "StudentLocation/\(objectId)"
                
            }
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskGetRequest<Dec: Decodable>(url: URL, decodable: Dec.Type, completion: @escaping (Dec?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(decodable.self, from: data)
                DispatchQueue.main.async {
                    completion(response,nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskPostRequest<Dec: Decodable, Enc: Encodable>(url: URL, body: Enc, decodable: Dec.Type, completion: @escaping (Dec?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(decodable.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(udacity: LoginCredentials(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            let newData = data.subdata(in: 5..<data.count)
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(LoginResponse.self, from: newData)
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(true,nil)
            }catch{
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func getStudentInformation(completion: @escaping ([StudentLocation], Error?) -> Void){
        
        taskGetRequest(url: Endpoints.getStudentLocation.url, decodable: StudentResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            }else{
                completion([], error)
            }
        }
        
    }
    
    class func postStudentLocation(studentInfo: StudentLocation, completiong: @escaping (Bool, Error?) -> Void ){
     
        let body = studentInfo
        taskPostRequest(url: Endpoints.postStudentLocation.url, body: body, decodable: SLResponse.self) { (response, error) in
            if let response = response {
                StudentInfo.studentInfo.createdAt = response.createdAt
                StudentInfo.studentInfo.objectId = response.objectId
                
            }
        }
        
    }
    
    class func putStudentLocation(objectId: String, completion: @escaping (Bool, Error?) -> Void){
     
        var request = URLRequest(url: Endpoints.putStudentLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = StudentInfo.studentInfo
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                print("Error #1")
                return
            }
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(PutSLResponse.self, from: data)
                UpdateInformation.updateInformation.updatedAt = response.updatedAt
                completion(true,nil)
            }catch{
                completion(false, nil)
                print("Error here")
            }
        }
        task.resume()
    }
    
}

