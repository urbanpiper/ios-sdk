//
//  APIManager+FCM.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 17/01/18.
//  Copyright © 2018 UrbanPiper Inc. All rights reserved.
//

import Foundation

extension APIManager {
    
    private struct UserDefaultsFCMKeys {
        static let BizFCMTokenKey: String = "BizFCMTokenKey"
        static let UserBizFCMTokenKey: String = "UserBizFCMTokenKey"
    }
    
    var lastRegisteredFCMToken: String? {
        get {
            if AppUserDataModel.shared.validAppUserData != nil {
                return UserDefaults.standard.string(forKey: UserDefaultsFCMKeys.UserBizFCMTokenKey)
            } else {
                return UserDefaults.standard.string(forKey: UserDefaultsFCMKeys.BizFCMTokenKey)
            }
        }
        set {
            if let token = newValue {
                if AppUserDataModel.shared.validAppUserData != nil {
                    return UserDefaults.standard.set(token, forKey: UserDefaultsFCMKeys.UserBizFCMTokenKey)
                } else {
                    return UserDefaults.standard.set(token, forKey: UserDefaultsFCMKeys.BizFCMTokenKey)
                }
            } else {
                if AppUserDataModel.shared.validAppUserData != nil {
                    return UserDefaults.standard.removeObject(forKey: UserDefaultsFCMKeys.UserBizFCMTokenKey)
                } else {
                    return UserDefaults.standard.removeObject(forKey: UserDefaultsFCMKeys.BizFCMTokenKey)
                }
            }
        }
    }

    @objc public func registerForFCMMessaging(token: String,
                                       completion: APICompletion<[String : Any]>?,
                                       failure: APIFailure?) -> URLSessionDataTask? {
        
        guard lastRegisteredFCMToken == nil || lastRegisteredFCMToken! != token else {
            completion?(nil)
            return nil
        }
        
        let urlString: String = "\(APIManager.baseUrl)/api/v1/device/fcm/"
        
        let url: URL = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let params: [String: Any] = ["registration_id": token,
                      "device_id": APIManager.uuidString,
                      "channel": APIManager.channel]
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                self?.lastRegisteredFCMToken = token
                guard let completionClosure = completion else { return }
                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {

                    DispatchQueue.main.async {
                        completionClosure(dictionary)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completionClosure(nil)
                }
            } else {
                if let failureClosure = failure {
                    guard let apiError: UPAPIError = UPAPIError(error: error, data: data) else { return }
                    DispatchQueue.main.async {
                        failureClosure(apiError as UPError)
                    }
                }
            }
            
        }
        
        return dataTask
    }
    
    @objc public func unRegisterForFCMMessaging(completion: APICompletion<[String: Any]>?,
                                         failure: APIFailure?) -> URLSessionDataTask? {
        let oldToken = UserDefaults.standard.string(forKey: UserDefaultsFCMKeys.UserBizFCMTokenKey)
        guard AppUserDataModel.shared.validAppUserData == nil, oldToken != nil else {
            completion?(nil)
            return nil
        }
        
        let urlString: String = "\(APIManager.baseUrl)/api/v1/device/fcm/"

        let url: URL = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let params: [String: Any] = ["registration_id": oldToken!,
                      "device_id": APIManager.uuidString,
                      "channel": APIManager.channel]
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                UserDefaults.standard.removeObject(forKey: UserDefaultsFCMKeys.UserBizFCMTokenKey)
                guard let completionClosure = completion else { return }

                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {

                    DispatchQueue.main.async {
                        completionClosure(dictionary)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completionClosure(nil)
                }
            } else {
                if let failureClosure = failure {
                    guard let apiError: UPAPIError = UPAPIError(error: error, data: data) else { return }
                    DispatchQueue.main.async {
                        failureClosure(apiError as UPError)
                    }
                }
            }
            
        }
        
        return dataTask
    }
}
