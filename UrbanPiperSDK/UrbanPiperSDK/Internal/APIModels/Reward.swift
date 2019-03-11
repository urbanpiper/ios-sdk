//
//  Reward.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 12, 2019

import Foundation


public class Reward : NSObject, NSCoding{

    public private(set)  var claimedCount : Int!
    public private(set)  var descriptionField : String!
    public private(set)  var expiresOn : Int!
    public private(set)  var id : Int!
    public private(set)  var imgLink : String!
    public private(set)  var inStoreCouponRewards : Bool!
    public private(set)  var locked : Bool!
    public private(set)  var points : Int!
    public private(set)  var redeemedCount : Int!
    public private(set)  var title : String!
    public private(set)  var type : Int!
    public private(set)  var value : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        claimedCount = dictionary["claimed_count"] as? Int
        descriptionField = dictionary["description"] as? String
        expiresOn = dictionary["expires_on"] as? Int
        id = dictionary["id"] as? Int
        imgLink = dictionary["img_link"] as? String
        inStoreCouponRewards = dictionary["in_store_coupon_rewards"] as? Bool
        locked = dictionary["locked"] as? Bool
        points = dictionary["points"] as? Int
        redeemedCount = dictionary["redeemed_count"] as? Int
        title = dictionary["title"] as? String
        type = dictionary["type"] as? Int
        value = dictionary["value"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if claimedCount != nil{
            dictionary["claimed_count"] = claimedCount
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if expiresOn != nil{
            dictionary["expires_on"] = expiresOn
        }
        if id != nil{
            dictionary["id"] = id
        }
        if imgLink != nil{
            dictionary["img_link"] = imgLink
        }
        if inStoreCouponRewards != nil{
            dictionary["in_store_coupon_rewards"] = inStoreCouponRewards
        }
        if locked != nil{
            dictionary["locked"] = locked
        }
        if points != nil{
            dictionary["points"] = points
        }
        if redeemedCount != nil{
            dictionary["redeemed_count"] = redeemedCount
        }
        if title != nil{
            dictionary["title"] = title
        }
        if type != nil{
            dictionary["type"] = type
        }
        if value != nil{
            dictionary["value"] = value
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required public init(coder aDecoder: NSCoder)
    {
        claimedCount = aDecoder.decodeObject(forKey: "claimed_count") as? Int
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        expiresOn = aDecoder.decodeObject(forKey: "expires_on") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        imgLink = aDecoder.decodeObject(forKey: "img_link") as? String
        inStoreCouponRewards = aDecoder.decodeObject(forKey: "in_store_coupon_rewards") as? Bool
        locked = aDecoder.decodeObject(forKey: "locked") as? Bool
        points = aDecoder.decodeObject(forKey: "points") as? Int
        redeemedCount = aDecoder.decodeObject(forKey: "redeemed_count") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        value = aDecoder.decodeObject(forKey: "value") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc public func encode(with aCoder: NSCoder)
    {
        if claimedCount != nil{
            aCoder.encode(claimedCount, forKey: "claimed_count")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if expiresOn != nil{
            aCoder.encode(expiresOn, forKey: "expires_on")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if imgLink != nil{
            aCoder.encode(imgLink, forKey: "img_link")
        }
        if inStoreCouponRewards != nil{
            aCoder.encode(inStoreCouponRewards, forKey: "in_store_coupon_rewards")
        }
        if locked != nil{
            aCoder.encode(locked, forKey: "locked")
        }
        if points != nil{
            aCoder.encode(points, forKey: "points")
        }
        if redeemedCount != nil{
            aCoder.encode(redeemedCount, forKey: "redeemed_count")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if value != nil{
            aCoder.encode(value, forKey: "value")
        }
    }
}