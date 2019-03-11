//
//  APIManager+Reorder.swift
//  UrbanPiperSDK
//
//  Created by Vidhyadharan Mohanram on 14/06/18.
//  Copyright © 2018 UrbanPiper. All rights reserved.
//

import Foundation
import CoreLocation

extension APIManager {

    internal func reorder(orderId: Int,
                        userLocation: CLLocationCoordinate2D?,
                        storeId: Int?,
                        completion: ((ReorderResponse?) -> Void)?,
                        failure: APIFailure?) -> URLSessionDataTask {

        var urlString: String = "\(APIManager.baseUrl)/api/v2/order/\(orderId)/reorder"

        if let location: CLLocationCoordinate2D = userLocation, location.latitude != 0, location.longitude != 0 {
            urlString = "\(urlString)/?lat=\(location.latitude)&lng=\(location.longitude)"
            if let storeId: Int = storeId {
                urlString = "\(urlString)&location_id=\(storeId)"
            }
        } else if let storeId: Int = storeId {
            urlString = "\(urlString)/?location_id=\(storeId)"
        }

        let url: URL = URL(string: urlString)!

        var urlRequest: URLRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"

        
        return apiRequest(urlRequest: urlRequest, responseParser: { (dictionary) -> ReorderResponse? in
            return ReorderResponse(fromDictionary: dictionary)
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let code = statusCode, code == 200 {
                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let reorderResponse: ReorderResponse = ReorderResponse(fromDictionary: dictionary)

                    DispatchQueue.main.async {
                        completion?(reorderResponse)
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