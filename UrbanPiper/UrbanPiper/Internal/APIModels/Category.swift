// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   public let itemCategory = try ItemCategory(json)

import Foundation

// MARK: - ItemCategory

@objcMembers public class ItemCategory: NSObject, Codable {
    public let id: Int
    public let name: String
    public let sortOrder: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sortOrder = "sort_order"
    }

    init(id: Int, name: String, sortOrder: Int?) {
        self.id = id
        self.name = name
        self.sortOrder = sortOrder
    }

    required convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ItemCategory.self, from: data)
        self.init(id: me.id, name: me.name, sortOrder: me.sortOrder)
    }
}

// MARK: Category convenience initializers and mutators

extension ItemCategory {
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
        id: Int? = nil,
        name: String? = nil,
        sortOrder: Int? = nil
    ) -> ItemCategory {
        ItemCategory(
            id: id ?? self.id,
            name: name ?? self.name,
            sortOrder: sortOrder ?? self.sortOrder
        )
    }

    func jsonData() throws -> Data {
        try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        String(data: try jsonData(), encoding: encoding)
    }
}