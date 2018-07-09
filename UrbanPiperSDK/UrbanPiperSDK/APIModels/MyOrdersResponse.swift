//
//	MyOrdersResponse.swift
//
//	Create by Vidhyadharan Mohanram on 16/6/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


public class MyOrdersResponse : NSObject{

	public var meta : MyOrderMeta!
	public var objects : [MyOrderObject]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let metaData: [String:Any] = dictionary["meta"] as? [String:Any]{
			meta = MyOrderMeta(fromDictionary: metaData)
		}
		objects = [MyOrderObject]()
		if let objectsArray: [[String:Any]] = dictionary["objects"] as? [[String:Any]]{
			for dic in objectsArray{
				let value: MyOrderObject = MyOrderObject(fromDictionary: dic)
				objects.append(value)
			}
		}
	}

//    /**
//     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//     */
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary: [String : Any] = [String:Any]()
//        if meta != nil{
//            dictionary["meta"] = meta.toDictionary()
//        }
//        if objects != nil{
//            var dictionaryElements: [[String:Any]] = [[String:Any]]()
//            for objectsElement in objects {
//                dictionaryElements.append(objectsElement.toDictionary())
//            }
//            dictionary["objects"] = dictionaryElements
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
//         meta = aDecoder.decodeObject(forKey: "meta") as? MyOrderMeta
//         objects = aDecoder.decodeObject(forKey :"objects") as? [MyOrderObject]
//
//    }
//
//    /**
//    * NSCoding required method.
//    * Encodes mode properties into the decoder
//    */
//    @objc public func encode(with aCoder: NSCoder)
//    {
//        if meta != nil{
//            aCoder.encode(meta, forKey: "meta")
//        }
//        if objects != nil{
//            aCoder.encode(objects, forKey: "objects")
//        }
//
//    }

}
