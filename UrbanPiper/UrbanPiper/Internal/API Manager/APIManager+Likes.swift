//
//  APIManager+Items.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 07/11/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import Foundation

extension APIManager {

    @objc func userLikes(offset: Int = 0,
                         limit: Int = Constants.fetchLimit,
                         completion: ((UserLikesResponse?) -> Void)?,
                         failure: APIFailure?) -> URLSessionDataTask {

        let urlString: String = "\(APIManager.baseUrl)/api/v1/user/item/likes/"

        let url: URL = URL(string: urlString)!

        var urlRequest: URLRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"

        
        return apiRequest(urlRequest: &urlRequest, responseParser: { (dictionary) -> UserLikesResponse? in
            return UserLikesResponse(fromDictionary: dictionary)
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let code = statusCode, (code == 200 || code == 204) {

                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let likesResponse: UserLikesResponse = UserLikesResponse(fromDictionary: dictionary)

                    DispatchQueue.main.async {
                        completion?(likesResponse)
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion?(nil)
                }
            } else {
                let errorCode = (error as NSError?)?.code
                self?.handleAPIError(httpStatusCode: statusCode, errorCode: errorCode, data: data, failureClosure: failure)
            }

        }

        return dataTask*/
    }

    @objc internal func likeItem(itemId: Int,
                              completion: ((GenericResponse?) -> Void)?,
                              failure: APIFailure?) -> URLSessionDataTask {

        let urlString: String = "\(APIManager.baseUrl)/api/v1/user/item/\(itemId)/like/"

        let url: URL = URL(string: urlString)!

        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        return apiRequest(urlRequest: &urlRequest, responseParser: { (dictionary) -> GenericResponse? in
            return GenericResponse(fromDictionary: dictionary) ?? GenericResponse.init()
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let code = statusCode, (code == 200 || code == 204) {
                
                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    
                    DispatchQueue.main.async {
                        completion?(dictionary)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } else {
                let errorCode = (error as NSError?)?.code
                self?.handleAPIError(httpStatusCode: statusCode, errorCode: errorCode, data: data, failureClosure: failure)
            }

        }

        return dataTask*/
    }
    
    @objc internal func unlikeItem(itemId: Int,
                                 completion: ((GenericResponse?) -> Void)?,
                                failure: APIFailure?) -> URLSessionDataTask {
        
        let urlString: String = "\(APIManager.baseUrl)/api/v1/user/item/\(itemId)/like/"
        
        let url: URL = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        return apiRequest(urlRequest: &urlRequest, responseParser: { (dictionary) -> GenericResponse? in
            return GenericResponse(fromDictionary: dictionary) ?? GenericResponse.init()
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
         
         let statusCode = (response as? HTTPURLResponse)?.statusCode
         if let code = statusCode, (code == 200 || code == 204) {
         
         if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
         
         DispatchQueue.main.async {
         completion?(dictionary)
         }
         return
         }
         
         DispatchQueue.main.async {
         completion?(nil)
         }
         } else {
         let errorCode = (error as NSError?)?.code
         self?.handleAPIError(httpStatusCode: statusCode, errorCode: errorCode, data: data, failureClosure: failure)
         }
         
         }
         
         return dataTask*/
    }

}
