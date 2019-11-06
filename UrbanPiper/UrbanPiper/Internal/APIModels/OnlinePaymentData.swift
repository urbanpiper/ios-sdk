// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   @objc public let dataClass = try DataClass(json)

import Foundation

public enum PaymentType: String {
    case paytm
    case paytabs
}

// MARK: - DataClass
@objc public class DataClass: NSObject, Codable {
    @objc public let website: String?
    @objc public let paymenturl: String?
    @objc public let orderID, mid: String?
    @objc public let overrideurl: Bool
    @objc public let channelID, industryTypeID, custID: String?
    @objc public let callbackURL: String?
    @objc public let type, checksumhash, txnAmount: String?
    @objc public let key: String?
    
    public var paymentType: PaymentType {
        return PaymentType(rawValue: type!)!
    }

    enum CodingKeys: String, CodingKey {
        case website = "WEBSITE"
        case paymenturl = "payment_url"
        case orderID = "ORDER_ID"
        case mid = "MID"
        case overrideurl = "override_url"
        case channelID = "CHANNEL_ID"
        case industryTypeID = "INDUSTRY_TYPE_ID"
        case custID = "CUST_ID"
        case callbackURL = "CALLBACK_URL"
        case type, key
        case checksumhash = "CHECKSUMHASH"
        case txnAmount = "TXN_AMOUNT"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.website = try values.decodeIfPresent(String.self, forKey: .website)
        self.paymenturl = try values.decodeIfPresent(String.self, forKey: .paymenturl)
        self.orderID = try values.decodeIfPresent(String.self, forKey: .orderID)
        self.mid = try values.decodeIfPresent(String.self, forKey: .mid)
        self.overrideurl = try values.decodeIfPresent(Bool.self, forKey: .overrideurl) ?? false
        self.channelID = try values.decodeIfPresent(String.self, forKey: .channelID)
        self.industryTypeID = try values.decodeIfPresent(String.self, forKey: .industryTypeID)
        self.custID = try values.decodeIfPresent(String.self, forKey: .custID)
        self.callbackURL = try values.decodeIfPresent(String.self, forKey: .callbackURL)
        self.type = try values.decodeIfPresent(String.self, forKey: .type)
        self.checksumhash = try values.decodeIfPresent(String.self, forKey: .checksumhash)
        self.txnAmount = try values.decodeIfPresent(String.self, forKey: .txnAmount)
        self.key = try values.decodeIfPresent(String.self, forKey: .key)
    }

    init(website: String?, paymenturl: String?, orderID: String?, mid: String?, overrideurl: Bool, channelID: String?, industryTypeID: String?, custID: String?, callbackURL: String?, type: String?, checksumhash: String?, txnAmount: String?, key: String?) {
        self.website = website
        self.paymenturl = paymenturl
        self.orderID = orderID
        self.mid = mid
        self.overrideurl = overrideurl
        self.channelID = channelID
        self.industryTypeID = industryTypeID
        self.custID = custID
        self.callbackURL = callbackURL
        self.type = type
        self.checksumhash = checksumhash
        self.txnAmount = txnAmount
        self.key = key
    }
    
    required convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(DataClass.self, from: data)
        self.init(website: me.website, paymenturl: me.paymenturl, orderID: me.orderID, mid: me.mid, overrideurl: me.overrideurl, channelID: me.channelID, industryTypeID: me.industryTypeID, custID: me.custID, callbackURL: me.callbackURL, type: me.type, checksumhash: me.checksumhash, txnAmount: me.txnAmount, key: me.key)
    }

}

// MARK: DataClass convenience initializers and mutators

extension DataClass {

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    public func with(
        website: String? = nil,
        paymenturl: String? = nil,
        orderID: String? = nil,
        mid: String? = nil,
        overrideurl: Bool? = nil,
        channelID: String? = nil,
        industryTypeID: String? = nil,
        custID: String? = nil,
        callbackURL: String? = nil,
        type: String? = nil,
        checksumhash: String? = nil,
        txnAmount: String? = nil,
        key: String? = nil
    ) -> DataClass {
        return DataClass(
            website: website ?? self.website,
            paymenturl: paymenturl ?? self.paymenturl,
            orderID: orderID ?? self.orderID,
            mid: mid ?? self.mid,
            overrideurl: overrideurl ?? self.overrideurl,
            channelID: channelID ?? self.channelID,
            industryTypeID: industryTypeID ?? self.industryTypeID,
            custID: custID ?? self.custID,
            callbackURL: callbackURL ?? self.callbackURL,
            type: type ?? self.type,
            checksumhash: checksumhash ?? self.checksumhash,
            txnAmount: txnAmount ?? self.txnAmount,
            key: key ?? self.key
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
