//
//  TestHelper.swift
//  SwiftyJSONFetch_Tests
//
//  Created by Thomas Marien on 21.10.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class TestHelper {
    static func validDataWithOptional() -> Data {
        return """
        {
            "id": "testId",
            "number": 123.4,
            "optionalNumber": 42
        }
        """.data(using: .utf8)!
    }
    
    static func validDataWithoutOptional() -> Data {
        return """
        {
            "id": "testId",
            "number": 123.4
        }
        """.data(using: .utf8)!
    }
    
    static func invalidData() -> Data {
        return """
        {
            "id" "testId",
            "number": 123.4
            "optionalNumber: 42"
        }
        """.data(using: .utf8)!
    }
    
    static func validBody() -> Data {
        return """
        {
            "key1": "value1",
            "key2": "value2",
            "key3": "value3"
        }
        """.data(using: .utf8)!
    }
}

struct ValidModel: Codable, Equatable {
    var id: String
    var number: Double
    var optionalNumber: Int?
    
    static func ==(lhs: ValidModel, rhs: ValidModel) -> Bool {
        return lhs.id == rhs.id && lhs.number == rhs.number && lhs.optionalNumber == rhs.optionalNumber
    }
}

struct InvalidModel: Codable {
    var foo: Double
    var bar: Int
}
