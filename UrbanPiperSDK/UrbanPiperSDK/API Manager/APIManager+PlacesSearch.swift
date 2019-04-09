//
//  APIManager+PlacesSearch.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 09/04/18.
//  Copyright © 2018 UrbanPiper Inc. All rights reserved.
//

import Foundation

extension APIManager {
    
    @objc public func fetchCoordinates(from placeId: String,
                                completion: ((PlaceDetailsResponse?) -> Void)?,
                                failure: APIFailure?) -> URLSessionDataTask {
        let placesAPIKey: String = AppConfigManager.shared.firRemoteConfigDefaults.googlePlacesApiKey!

        var urlString: String = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&sensor=false&key=\(placesAPIKey)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url: URL = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            let errorCode = (error as NSError?)?.code
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? errorCode
            if statusCode == 200 {
                guard let completionClosure = completion else { return }
                
                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let placeDetailsResponse: PlaceDetailsResponse = PlaceDetailsResponse(fromDictionary: dictionary)
                    
                    DispatchQueue.main.async {
                        completionClosure(placeDetailsResponse)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completionClosure(nil)
                }
            } else {
                self?.handleAPIError(httpStatusCode: statusCode, errorCode: errorCode, data: data, failureClosure: failure)
            }
            
        }
        
        return dataTask
    }
    
    @objc public func reverseGeoCode(lat: Double,
                                     lng: Double,
                                       completion: ((Address?) -> Void)?,
                                       failure: APIFailure?) -> URLSessionDataTask {
        let placesAPIKey: String = AppConfigManager.shared.firRemoteConfigDefaults.googlePlacesApiKey!
        
        var urlString: String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&key=\(placesAPIKey)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url: URL = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            let errorCode = (error as NSError?)?.code
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? errorCode
            if statusCode == 200 {
                guard let completionClosure = completion else { return }
                
                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let placeDetailsResponse: PlaceDetailsResponse = PlaceDetailsResponse(fromDictionary: dictionary)
                    
                    if let address = Address(placeDetailsResponse: placeDetailsResponse) {
                        DispatchQueue.main.async {
                            completionClosure(address)
                        }
                        return
                    }
                    
                }
                
                DispatchQueue.main.async {
                    completionClosure(nil)
                }
            } else {
                self?.handleAPIError(httpStatusCode: statusCode, errorCode: errorCode, data: data, failureClosure: failure)
            }
            
        }
        
        return dataTask
    }
    
    @objc public func fetchPlaces(for keyword: String,
                                  completion: ((GooglePlacesResponse?) -> Void)?,
                                  failure: APIFailure?) -> URLSessionDataTask {
        
        let bizCountry2LetterCode: String
        
        if let countryCode = AppConfigManager.shared.firRemoteConfigDefaults.bizCountry2LetterCode, countryCode.count > 0 {
            bizCountry2LetterCode = countryCode
        } else {
            bizCountry2LetterCode = "IN"
        }
        
        let placesAPIKey: String = AppConfigManager.shared.firRemoteConfigDefaults.googlePlacesApiKey!
        
        var urlString: String = "https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&key=\(placesAPIKey)&components=country:\(bizCountry2LetterCode)&input=\(keyword)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url: URL = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            let errorCode = (error as NSError?)?.code
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? errorCode
            if statusCode == 200 {
                guard let completionClosure = completion else { return }
                
                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let placesResponse: GooglePlacesResponse = GooglePlacesResponse(fromDictionary: dictionary)
                    
                    DispatchQueue.main.async {
                        completionClosure(placesResponse)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completionClosure(nil)
                }
            } else {
                self?.handleAPIError(httpStatusCode: statusCode, errorCode: errorCode, data: data, failureClosure: failure)
            }
            
        }
        
        return dataTask
    }
    
}
