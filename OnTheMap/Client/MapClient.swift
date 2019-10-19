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
        case getStudentInformation
        case postStudentLocation
        case putStudentLocation(String)
        case getUserUpdate
        case logout

        var stringValue: String{
            switch self {
            case .login: return Endpoints.base + "/session"
            case .getStudentInformation: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation(let object): return Endpoints.base + "StudentLocation/\(object)"
            case .getUserUpdate: return Endpoints.base + "/users/\(Auth.accountId)"
            case .logout: return Endpoints.base + "/session"
                
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
        request.addValue("application/json", forHTTPHeaderField: "Accept")
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
            let newData = data.subdata(in: 5..<data.count)
            do{
                let response = try decoder.decode(decodable.self, from: newData)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            }catch{
                do{
                    let responseObject = try decoder.decode(StatusResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, responseObject)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        
        let body = LoginRequest(udacity: LoginCredentials(username: username, password: password))
        taskPostRequest(url: Endpoints.login.url, body: body, decodable: LoginResponse.self) { (response, error) in
            if let response = response{
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(true,nil)
            }else{
                completion(false, error)
            }
        }
        
    }
    
    class func getStudentInformation(completion: @escaping ([StudentInformation], Error?) -> Void){
        
        taskGetRequest(url: Endpoints.getStudentInformation.url, decodable: StudentResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            }else{
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(postData: StudentInformation,completion: @escaping (PostSLResponse?, Error?) -> Void){
     
        let body = postData
        taskPostRequest(url: Endpoints.postStudentLocation.url, body: body, decodable: PostSLResponse.self) { (response, error) in
            if let response = response{
                completion(response,nil)
            }else{
                print("ERROR IN POST SL")
                completion(nil, error)
            }
        }
        
    }
    
    class func putStudentLocation(objectId: String, data: StudentInformation, completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.putStudentLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = data
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(PutSLResponse.self, from: data)
                PutSLUpdated.putSLUpdated.updatedAt = responseObject.updatedAt
                completion(true,nil)
            }catch{
                completion(false, nil)
                print("ERROR IN PUT SL")
            }
        }
        task.resume()
    }
    
    class func updateUser(completion: @escaping (UserUpdate?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: Endpoints.getUserUpdate.url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)
            do{
                let responseObject = try decoder.decode(UserUpdate.self, from: newData)
                completion(responseObject, nil)
            }catch{
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                Auth.sessionId = ""
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }else{
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
}

