//
//	PlaceDetailsResponse.swift
//
//	Create by Vidhyadharan Mohanram on 11/4/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


public class PlaceDetailsResponse : NSObject{

	public private(set)  var htmlAttributions : [AnyObject]!
	public private(set)  var result : Result?
	public private(set)  var status : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	internal init(fromDictionary dictionary:  [String:Any]){
		htmlAttributions = dictionary["html_attributions"] as? [AnyObject]
		if let resultData: [String:Any] = dictionary["result"] as? [String:Any]{
			result = Result(fromDictionary: resultData)
        } else if let resultsData: [[String:Any]] = dictionary["results"] as? [[String:Any]] {
            for resultData in resultsData {
                let resultObject = Result(fromDictionary: resultData)
                guard resultObject.geometry?.location?.lat != nil, resultObject.geometry?.location?.lng != nil else { continue }
                result = resultObject
                return
            }
        }
		status = dictionary["status"] as? String
	}

//    /**
//     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//     */
//    public func toDictionary() -> [String:Any]
//    {
//        var dictionary: [String: Any] = [String:Any]()
//        if htmlAttributions != nil{
//            dictionary["html_attributions"] = htmlAttributions
//        }
//        if result != nil{
//            dictionary["result"] = result.toDictionary()
//        }
//        if status != nil{
//            dictionary["status"] = status
//        }
//        return dictionary
//    }
//
//    /**
//    * NSCoding required initializer.
//    * Fills the data from the passed decoder
//    */
//    @objc required public init(coder aDecoder: NSCoder)
//    {
//         htmlAttributions = aDecoder.decodeObject(forKey: "html_attributions") as? [AnyObject]
//         result = aDecoder.decodeObject(forKey: "result") as? Result
//         status = aDecoder.decodeObject(forKey: "status") as? String
//
//    }
//
//    /**
//    * NSCoding required method.
//    * Encodes mode properties into the decoder
//    */
//    @objc public func encode(with aCoder: NSCoder)
//    {
//        if htmlAttributions != nil{
//            aCoder.encode(htmlAttributions, forKey: "html_attributions")
//        }
//        if result != nil{
//            aCoder.encode(result, forKey: "result")
//        }
//        if status != nil{
//            aCoder.encode(status, forKey: "status")
//        }
//
//    }

}