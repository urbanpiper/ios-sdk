//
//  Referral.swift
//  UrbanPiper
//
//  Created by Vid on 28/12/18.
//

import UIKit

@objc public class Referral: NSObject, Codable {
    
    @objc public let codeLink: String
    @objc public let referrerCard: String
    @objc public let channel: String
    @objc public let sharedOn: String
    @objc public let platform: String

    public required init?(fromDictionary dictionary: [String: AnyObject]?) {
        guard let dictionary = dictionary else { return nil }

        var referralLink = dictionary["~referring_link"] as? String
        if referralLink == nil || referralLink!.count == 0 {
            referralLink = dictionary["link_to_share"] as? String
        }
        codeLink = referralLink!
        referrerCard = dictionary["card"] as! String
        channel = dictionary["~channel"] as! String
        sharedOn = dictionary["link_share_time"] as! String
        platform = dictionary["~creation_source"] as! String
    }
    
    enum CodingKeys: String, CodingKey {
        case codeLink = "code_link"
        case referrerCard = "referrer_card"
        case channel = "channel"
        case sharedOn = "shared_on"
        case platform = "platform"
    }
    
    init(codeLink: String, referrerCard: String, channel: String, sharedOn: String, platform: String) {
        self.codeLink = codeLink
        self.referrerCard = referrerCard
        self.channel = channel
        self.sharedOn = sharedOn
        self.platform = platform
    }

    required convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Referral.self, from: data)
        self.init(codeLink: me.codeLink, referrerCard: me.referrerCard, channel: me.channel, sharedOn: me.sharedOn, platform: me.platform)
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc public required init(coder aDecoder: NSCoder) {
        codeLink = aDecoder.decodeObject(forKey: "code_link") as! String
        referrerCard = aDecoder.decodeObject(forKey: "referrer_card") as! String
        channel = aDecoder.decodeObject(forKey: "channel") as! String
        sharedOn = aDecoder.decodeObject(forKey: "shared_on") as! String
        platform = aDecoder.decodeObject(forKey: "platform") as! String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc public func encode(with aCoder: NSCoder) {
        aCoder.encode(codeLink, forKey: "code_link")
        aCoder.encode(referrerCard, forKey: "referrer_card")
        aCoder.encode(channel, forKey: "channel")
        aCoder.encode(sharedOn, forKey: "shared_on")
        aCoder.encode(platform, forKey: "platform")
    }
}
