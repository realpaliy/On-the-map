//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

class ParseClient{
    
    static var res = [StudentResponse]()
    
    struct Auth {
        static var accountId = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    
    case login
    
    var stringValue: String {
        switch self {
        case .login: return Endpoints.base + "/session"
        }
        
    }
    
    var url: URL {
        return URL(string: stringValue)!
        }
    }
    
    func postRequest<B : Encodable, R: Decodable>(_ url: URL, _ body: B, _ completion: @escaping (OTMResult<R>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            self.handleResponse(data, error, completion)
        }
        task.resume()
    }
    
    func handleResponse<T: Decodable>(_ data: Data?, _ error: Error? ,_ completion: @escaping (OTMResult<T>) -> Void) {
        let errorDescription = error?.localizedDescription ?? "Error"
        var result: OTMResult<T>!
        if let data = data {
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data)
                result = OTMResult.success(responseObject)
            } catch {
                let errorResponse = try? decoder.decode(OTMErrorResponse.self, from: data)
                result = OTMResult.error(errorResponse?.error ?? errorDescription)
            }
        } else {
            result = OTMResult.error(errorDescription)
        }
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    class func getStudentLocation(completion: @escaping (Bool, Error?) -> Void){
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                print("Error1 in getStudentLocation")
                return
            }
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(StudentResponse.self, from: data)
                print(response.studentResponse)
                completion(true, nil)
            }catch{
                completion(false, error)
                print("Error2 in getStudentLocation")
            }
        }
        task.resume()
    }
    class func postStudentLocation(studentLocation: StudentLocation,completion: @escaping (Bool, Error?) -> Void){
           
           var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           let body = studentLocation
           request.httpBody = try! JSONEncoder().encode(body)
           
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               guard let data = data else {
                   completion(false, error)
                   print("Error1 in PostStudentLocation")
                   return
               }
               let decoder = JSONDecoder()
               do{
                   let response = try decoder.decode(PostSLResponse.self, from: data)
                   PostSL.studentLocation.createdAt = response.createdAt
                   PostSL.studentLocation.objectId = response.objectId
                   completion(true,nil)
               }catch{
                   completion(false, error)
                   print("Error2 in PostStudentLocation")
               }
           }
           task.resume()
       }
       
       func login(_ username: String,_ password: String, completion: @escaping (OTMResult<LoginResponse>) -> Void){
           
          var request = URLRequest(url: Endpoints.login.url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Accept")
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          let body = LoginRequest(udacity: LoginCredentials(username: username, password: password))
          request.httpBody = try! JSONEncoder().encode(body)
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                  let subData = data.subdata(in: 5..<data.count)
                  self.handleResponse(subData, error, completion)
              } else {
                  self.handleResponse(data, error, completion)
              }
          }
          task.resume()
           
       }
}

