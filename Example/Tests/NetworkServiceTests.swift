//
//  NetworkServiceTests.swift
//  SwiftyJSONFetch_Tests
//
//  Created by Thomas Marien on 21.10.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import SwiftyJSONFetch


class NetworkServiceTests: XCTestCase {
    
    func test_fetch_validRequest_returnsData() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(data: TestHelper.validDataWithOptional(),
                                       statusCode: 200,
                                       headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = URL(string: "http://www.test.org")!
        let parameters = ["key1":"value1", "key2": "value2"]
        let body = TestHelper.validBody()
        let header = ["Content-Type":"application/json"]
        
        NetworkService().fetch(url: url, parameters: parameters, bodyData: body, method: .get, header: header) { (data, error) in
            XCTAssertEqual(data, TestHelper.validDataWithOptional())
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetch_validRequest_returnsError() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(error: NSError(domain: "de.tomte", code: 404, userInfo: nil))
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = URL(string: "http://www.test.org")!
        let parameters = ["key1":"value1", "key2": "value2"]
        let body = TestHelper.validBody()
        let header = ["Content-Type":"application/json"]
        
        NetworkService().fetch(url: url, parameters: parameters, bodyData: body, method: .get, header: header) { (data, error) in
            XCTAssertEqual(error!.errorDescription, "The operation couldn’t be completed. (de.tomte error 404.)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetch_validRequest_emptyParameters_returnsData() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(data: TestHelper.validDataWithOptional(),
                                       statusCode: 200,
                                       headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = URL(string: "http://www.test.org")!
        
        NetworkService().fetch(url: url, parameters: [:], bodyData: nil, method: .get, header: [:]) { (data, error) in
            XCTAssertEqual(data, TestHelper.validDataWithOptional())
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
    }
}
