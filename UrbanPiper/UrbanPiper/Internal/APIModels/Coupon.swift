// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   @objc public let coupon = try Coupon(json)

import Foundation

// MARK: - Coupon
@objc public class Coupon: NSObject, Codable {
    @objc public let couponDescription, redemptionCode, title: String
    @objc public let validUntil: Date?

    enum CodingKeys: String, CodingKey {
        case couponDescription = "description"
        case redemptionCode = "redemption_code"
        case title
        case validUntil = "valid_until"
    }

    init(couponDescription: String, redemptionCode: String, title: String, validUntil: Date?) {
        self.couponDescription = couponDescription
        self.redemptionCode = redemptionCode
        self.title = title
        self.validUntil = validUntil
    }
    
    required convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Coupon.self, from: data)
        self.init(couponDescription: me.couponDescription, redemptionCode: me.redemptionCode, title: me.title, validUntil: me.validUntil)
    }
}

// MARK: Coupon convenience initializers and mutators

extension Coupon {

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
        couponDescription: String? = nil,
        redemptionCode: String? = nil,
        title: String? = nil,
        validUntil: Date? = nil
    ) -> Coupon {
        return Coupon(
            couponDescription: couponDescription ?? self.couponDescription,
            redemptionCode: redemptionCode ?? self.redemptionCode,
            title: title ?? self.title,
            validUntil: validUntil ?? self.validUntil
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
