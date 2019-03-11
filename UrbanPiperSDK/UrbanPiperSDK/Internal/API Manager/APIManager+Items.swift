//
//  APIManager+Items.swift
//  WhiteLabel
//
//  Created by Vidhyadharan Mohanram on 07/11/17.
//  Copyright © 2017 UrbanPiper Inc. All rights reserved.
//

import Foundation

extension APIManager {
    
    func getFilterAndSortOptions(id: Int,
                            completion: ((CategoryOptionsResponse?) -> Void)?,
                            failure: APIFailure?) -> URLSessionDataTask {
        
        var urlString: String = "\(APIManager.baseUrl)/api/v2/categories/\(id)/options/"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url: URL = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue(bizAuth(), forHTTPHeaderField: "Authorization")

        
        return apiRequest(urlRequest: urlRequest, responseParser: { (dictionary) -> CategoryOptionsResponse? in
            return CategoryOptionsResponse(fromDictionary: dictionary)
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let code = statusCode, code == 200 {
                
                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let categoryOptionsResponse: CategoryOptionsResponse = CategoryOptionsResponse(fromDictionary: dictionary)
                    
                    DispatchQueue.main.async {
                        completion?(categoryOptionsResponse)
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

    func getCategoryItems(categoryId: Int,
                            storeId: Int?,
                            offset: Int = 0,
                            limit: Int = Constants.fetchLimit,
                            sortKey: String? = nil,
                            filterOptions: [FilterOption]? = nil,
//                            isForcedRefresh: Bool,
//                            next: String?,
                            completion: ((CategoryItemsResponse?) -> Void)?,
                            failure: APIFailure?) -> URLSessionDataTask {

        var urlString: String = "\(APIManager.baseUrl)/api/v1/order/categories/\(categoryId)/items/?format=json&offset=\(offset)&limit=\(limit)&biz_id=\(bizId)"

        if let id = storeId {
            urlString = "\(urlString)&location_id=\(id)"
        }
        
        if let key = sortKey {
            urlString = "\(urlString)&sort_by=\(key)"
        }
        
        if let options = filterOptions, options.count > 0 {
            let keysArray = options.map { String($0.id!) }
            let filterKeysString = keysArray.joined(separator: ",")
            urlString = "\(urlString)&filter_by=\(filterKeysString)"
        }
        
//        if let nextUrlString: String = next {
//            urlString = "\(APIManager.baseUrl)\(nextUrlString)"
//        }

        let url: URL = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!

        var urlRequest: URLRequest = URLRequest(url: url)
//        , cachePolicy: isForcedRefresh ? .reloadIgnoringLocalAndRemoteCacheData : .useProtocolCachePolicy)

        urlRequest.httpMethod = "GET"

        
        return apiRequest(urlRequest: urlRequest, responseParser: { (dictionary) -> CategoryItemsResponse? in
            return CategoryItemsResponse(fromDictionary: dictionary)
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let code = statusCode, code == 200 {

                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let categoryItemsResponse: CategoryItemsResponse = CategoryItemsResponse(fromDictionary: dictionary)

                    DispatchQueue.main.async {
                        completion?(categoryItemsResponse)
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

    func searchItems(query: String,
                            storeId: Int?,
                            offset: Int = 0,
                            limit: Int = Constants.fetchLimit,
                            completion: ((ItemsSearchResponse?) -> Void)?,
                            failure: APIFailure?) -> URLSessionDataTask {

        var urlString: String = "\(APIManager.baseUrl)/api/v2/search/items/?keyword=\(query)&offset=\(offset)&limit=\(limit)&biz_id=\(bizId)"
        
//        if let nextUrlString: String = next {
//            urlString = "\(APIManager.baseUrl)\(nextUrlString)"
//        }
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        if let id = storeId {
            urlString = urlString.appending("&location_id=\(id)")
        }

        let url: URL = URL(string: urlString)!

        var urlRequest: URLRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"

        
        return apiRequest(urlRequest: urlRequest, responseParser: { (dictionary) -> ItemsSearchResponse? in
            return ItemsSearchResponse(fromDictionary: dictionary)
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let code = statusCode, code == 200 {

                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let itemsSearchResponse: ItemsSearchResponse = ItemsSearchResponse(fromDictionary: dictionary)
                    DispatchQueue.main.async {
                        completion?(itemsSearchResponse)
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

    func getItemDetails(itemId: Int,
                          storeId: Int?,
                          completion: ((Item?) -> Void)?,
                          failure: APIFailure?) -> URLSessionDataTask {

        var urlString: String = "\(APIManager.baseUrl)/api/v1/items/\(itemId)/"

        let now: Date = Date()
        let timeInt = now.timeIntervalSince1970 * 1000

        if let id = storeId {
            urlString = urlString.appending("?location_id=\(id)&cx=\(timeInt)")
        } else {
            urlString = urlString.appending("?cx=\(timeInt)")
        }

        let url: URL = URL(string: urlString)!

        var urlRequest: URLRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"

        
        return apiRequest(urlRequest: urlRequest, responseParser: { (dictionary) -> Item? in
            let item = Item(fromDictionary: dictionary)
            item.isItemDetailsItem = true
            return item
        }, completion: completion, failure: failure)!
        
        /*let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let code = statusCode, code == 200 {

                if let jsonData: Data = data, let JSON: Any = try? JSONSerialization.jsonObject(with: jsonData, options: []), let dictionary: [String: Any] = JSON as? [String: Any] {
                    let item: Item = Item(fromDictionary: dictionary)

                    DispatchQueue.main.async {
                        completion?(item)
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
