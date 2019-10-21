//
//  CodingServiceTests.swift
//  SwiftyJSONFetch_Tests
//
//  Created by Thomas Marien on 20.10.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftyJSONFetch

class CodingServiceTests: XCTestCase {

    func test_decode_validData_returnsValidModel() {
        let service = CodingService()
        
        let data = TestHelper.validDataWithOptional()
        
        let object = service.decode(data: data, asType: ValidModel.self)
        
        XCTAssertEqual(object.decoded?.id, "testId")
        XCTAssertEqual(object.decoded?.number, 123.4)
        XCTAssertEqual(object.decoded?.optionalNumber, 42)
        XCTAssertNil(object.error)
    }
    
    func test_decode_validDataWithoutOptional_returnsValidModel() {
        let service = CodingService()
        
        let data = TestHelper.validDataWithoutOptional()
        
        let object = service.decode(data: data, asType: ValidModel.self)
        
        XCTAssertEqual(object.decoded?.id, "testId")
        XCTAssertEqual(object.decoded?.number, 123.4)
        XCTAssertNil(object.decoded?.optionalNumber)
        XCTAssertNil(object.error)
    }
    
    func test_decode_invalidData_returnsError() {
        let service = CodingService()
        
        let data = TestHelper.invalidData()
        
        let object = service.decode(data: data, asType: ValidModel.self)
        
        XCTAssertEqual(object.error?.errorDescription, "The data couldn’t be read because it isn’t in the correct format.")
        XCTAssertNil(object.decoded)
    }

    func test_decode_validData_wrongModel_returnsError() {
        let service = CodingService()
        
        let data = TestHelper.validDataWithOptional()
        
        let object = service.decode(data: data, asType: InvalidModel.self)
        
        XCTAssertEqual(object.error?.errorDescription, "The data couldn’t be read because it is missing.")
        XCTAssertNil(object.decoded)
    }
    
    func test_decode_emptyData_returnsError() {
        let service = CodingService()

        let object = service.decode(data: Data(), asType: ValidModel.self)
        
        XCTAssertEqual(object.error?.errorDescription, "The data couldn’t be read because it isn’t in the correct format.")
        XCTAssertNil(object.decoded)
    }
}
