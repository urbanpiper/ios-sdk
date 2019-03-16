//
//  RedeemRewardResponse.swift
//  UrbanPiper
//
//  Created by Vid on 12/02/19.
//

import UIKit

public class RedeemRewardResponse: NSObject {
    
    public private(set) var expiresIn : Int!
    public private(set) var ptsRemaining : Int!
    public private(set) var redemptionCode : String!
    public private(set) var status : String!
    public private(set) var message : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        expiresIn = dictionary["expires_in"] as? Int
        ptsRemaining = dictionary["ptsRemaining"] as? Int
        redemptionCode = dictionary["redemption_code"] as? String
        status = dictionary["status"] as? String
        message = dictionary["message"] as? String
    }
    
    @objc public func toDictionary() -> [String:Any] {
        var dictionary: [String: Any] = [String:Any]()
        
        if expiresIn != nil{
            dictionary["expires_in"] = expiresIn
        }
        
        if ptsRemaining != nil{
            dictionary["ptsRemaining"] = ptsRemaining
        }
        
        if redemptionCode != nil{
            dictionary["redemption_code"] = redemptionCode
        }
        
        if status != nil{
            dictionary["status"] = status
        }
        
        if message != nil{
            dictionary["message"] = message
        }
        
        return dictionary
    }
}