//
//  APIManager+Notifications.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 07/11/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import Foundation

extension APIManager {

    @objc public func fetchNotificationsList(completion: ((NotificationsResponse?) -> Void)?,
                                      failure: APIFailure?) -> URLSessionDataTask {

        let urlString: String = "\(APIManager.baseUrl)/api/v1/ub/notifications/?channel__in=app_notification,all"

        let url: URL = URL(string: urlString)!

        var urlRequest: URLRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"

        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in

            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                guard let completionClosure = completion else { return }

                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let notificationsResponse: NotificationsResponse = NotificationsResponse(fromDictionary: dictionary)

                    DispatchQueue.main.async {
                        completionClosure(notificationsResponse)
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

