//
//  API.swift
//  OnTheMap
//
//  Created by Noha on 27.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit

enum APIError: Error {
    case generic(Error)
    case noResponse
    case misformattedResponse
    case missingKey
    case login(message: String)
    
    var message: String {
        switch self {
            case .login(let message):
                return message
            default:
                return "Something went wrong. Please try again"
        }
    }
}

class API {

    static let instance = API()

    private var studentKey: String?
    private var studentName: String?

    func login(username: String, password: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
            {"udacity":
            {
            "username": "\(username)",
            "password": "\(password)"
            }
            }
            """.data(using: .utf8)

        sendRequest(request) {[weak self] result in

            let keyResult = result.flatMap { (parsedData: [String: Any]) -> Result<String, APIError> in

                if let error = parsedData["error"] as? String {
                    return .failure(.login(message: error))
                }


                guard let accountInfo = parsedData["account"] as? [String: AnyObject],
                    let key = accountInfo["key"] as? String else {
                        return .failure(.missingKey)
                }

                return .success(key)
            }

            if case .success(let key) = keyResult {
                self?.studentKey = key
            }

            DispatchQueue.main.async {
                completion(keyResult.map { _ in })
            }
        }
    }

    typealias Name = (firstName: String, lastName: String)
    func getStudent(_ completion: @escaping (Result<Name, APIError>) -> Void) {
        guard let uniqueKey = self.studentKey else {
            completion(.failure(.missingKey))
            return
        }
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(uniqueKey)")!)

        sendRequest(request, truncate: true) { result in
            let studentResult = result.flatMap { parsedData -> Result<Name, APIError> in
                guard let lastName = parsedData["last_name"] as? String,
                    let firstName = parsedData["first_name"] as? String else {
                        return .failure(.misformattedResponse)
                }

                return .success(Name(firstName, lastName))
            }


            DispatchQueue.main.async {
                completion(studentResult)
            }
        }
    }

    func loadStudentInformation(_ completion: @escaping (Result<[StudentInformation], APIError>) -> Void) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        sendRequest(request, truncate: false) { result in
            let infoResult = result.flatMap { (response: [String: Any]) -> Result<[StudentInformation], APIError> in
                guard let results = response["results"] as? [[String: Any]] else {
                    return .failure(.misformattedResponse)
                }

                var students: [StudentInformation] = []
                for item in results {
                    let student = StudentInformation(dictionary: item)
                    students.append(student)
                }

                return .success(students)
            }

            DispatchQueue.main.async {
                completion(infoResult)
            }
        }
    }

    func postStundentLocation(firstName: String, lastName: String, mapString: String, latitude: Double, longitude: Double, urlString: String, completion: @escaping (Result<Void, APIError>)-> Void) {

        guard let uniqueKey = self.studentKey else {
            completion(.failure(.missingKey))
            return
        }

        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
            {
            "uniqueKey": "\(uniqueKey)",
            "firstName": "\(firstName)",
            "lastName" : "\(lastName)",
            "mapString": "\(mapString)",
            "mediaURL" : "\(urlString)",
            "latitude" : \(latitude),
            "longitude" : \(longitude)
            }
            """.data(using: .utf8)

        sendRequest(request,truncate: false){ result in
            DispatchQueue.main.async {
                completion(result.map { _ in })
            }
        }
    }
    
   

    func logout(_ completion: @escaping (Result<Void, APIError>) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        sendRequest(request, truncate: true) {[weak self] result in

            // Remove saved student key
            if case .success = result {
                self?.studentKey = nil
            }

            DispatchQueue.main.async {
                completion(result.map { _ in })
            }
        }
    }
}

//MARK: Private
extension API {
    private func sendRequest(_ request: URLRequest, truncate: Bool = true, completion: @escaping (Result<[String: Any], APIError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.generic(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noResponse))
                return
            }

            let range = 5..<data.count
            let newData = truncate ? data.subdata(in: range) /* subset response data! */ : data

            do {
                if let parsedData = try JSONSerialization.jsonObject(with: newData, options: .fragmentsAllowed) as? [String: Any] {
                    completion(.success(parsedData))
                } else {
                    completion(.failure(.misformattedResponse))
                }
            } catch {
                completion(.failure(.misformattedResponse))
            }
        }
        task.resume()
    }
}
