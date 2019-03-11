//
//	BizInfo.swift
//
//	Create by Vidhyadharan Mohanram on 17/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


public class UserBizInfoResponse : NSObject, NSCoding{

	public private(set)  var meta : Meta!
	@objc public private(set)  var userBizInfos : [UserBizInfo]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	internal init(fromDictionary dictionary:  [String:Any]){
		if let metaData: [String:Any] = dictionary["meta"] as? [String:Any]{
			meta = Meta(fromDictionary: metaData)
		}
		userBizInfos = [UserBizInfo]()
		if let objectsArray: [[String:Any]] = dictionary["objects"] as? [[String:Any]]{
			for dic in objectsArray{
				let value: UserBizInfo = UserBizInfo(fromDictionary: dic)
				userBizInfos.append(value)
			}
		}
	}

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    public func toDictionary() -> [String:Any]
    {
        var dictionary: [String: Any] = [String:Any]()
        if meta != nil{
            dictionary["meta"] = meta.toDictionary()
        }
        if userBizInfos != nil{
            var dictionaryElements: [[String:Any]] = [[String:Any]]()
            for userBizInfo in userBizInfos {
                dictionaryElements.append(userBizInfo.toDictionary())
            }
            dictionary["objects"] = dictionaryElements
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required public init(coder aDecoder: NSCoder)
	{
        meta = aDecoder.decodeObject(forKey: "meta") as? Meta
        userBizInfos = aDecoder.decodeObject(forKey: "objects") as? [UserBizInfo]
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc public func encode(with aCoder: NSCoder)
	{
		if meta != nil{
			aCoder.encode(meta, forKey: "meta")
		}
		if userBizInfos != nil{
			aCoder.encode(userBizInfos, forKey: "objects")
		}

	}

}