//
//  SwiftyJSONFetchTests.swift
//  SwiftyJSONFetch_Tests
//
//  Created by Thomas Marien on 21.10.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import SwiftyJSONFetch

class SwiftyJSONFetchTests: XCTestCase {

    //MARK: - fetch from url tests
    func test_fetchFormURL_fullChain_returnsValidObject() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(data: TestHelper.validDataWithOptional(),
                                       statusCode: 200,
                                       headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = "http://www.test.org"
        let parameters = ["key1":"value1", "key2": "value2"]
        let body = TestHelper.validBody()
        let header = ["Content-Type":"application/json"]
        
        let modelToCompare = ValidModel(id: "testId", number: 123.4, optionalNumber: 42)
        
        SwiftyJSONFetch().body(body).header(header).parameters(parameters).method(.post).fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
            XCTAssertEqual(response, modelToCompare)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetchFormURL_noChain_returnsValidObject() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(data: TestHelper.validDataWithOptional(),
                                       statusCode: 200,
                                       headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = "http://www.test.org"
        
        let modelToCompare = ValidModel(id: "testId", number: 123.4, optionalNumber: 42)
        
        SwiftyJSONFetch().fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
            XCTAssertEqual(response, modelToCompare)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetchFormURL_fullChain_returnsError() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(error: NSError(domain: "de.tomte", code: 404, userInfo: nil))
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = "http://www.test.org"
        let parameters = ["key1":"value1", "key2": "value2"]
        let body = TestHelper.validBody()
        let header = ["Content-Type":"application/json"]
        
        SwiftyJSONFetch().body(body).header(header).parameters(parameters).method(.post).fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
            XCTAssertEqual(error!.errorDescription, "The operation couldn’t be completed. (de.tomte error 404.)")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetchFormURL_noChain_returnsError() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(error: NSError(domain: "de.tomte", code: 404, userInfo: nil))
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = "http://www.test.org"
        
        SwiftyJSONFetch().fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
            XCTAssertEqual(error!.errorDescription, "The operation couldn’t be completed. (de.tomte error 404.)")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetchFormURL_invalidURL_returnsError() {
        let expectation = self.expectation(description: "Network")
        
        let url = " _74 hd j&5 nbsh"
        
        SwiftyJSONFetch().fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
            XCTAssertEqual(error!.errorDescription, "URL could not be created from string:  _74 hd j&5 nbsh")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetchFormURL_nilResponse_returnsError() {
        let expectation = self.expectation(description: "Network")
        
        let url = "http://www.test.org"
        let mockNetworkService = MockNetworkService()
        mockNetworkService.isNilResponse = true
        
        SwiftyJSONFetch(networkService: mockNetworkService).fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
            XCTAssertEqual(error!.errorDescription, "No data in response!")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetchFormURL_emptyResponse_returnsError() {
        let expectation = self.expectation(description: "Network")
        
        let url = "http://www.test.org"
        let mockNetworkService = MockNetworkService()
        mockNetworkService.isEmptyResponse = true
        
        SwiftyJSONFetch(networkService: mockNetworkService).fetch(fromURLString: url, forType: ValidModel.self) { (response, error) in
            XCTAssertEqual(error!.errorDescription, "No data in response!")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetchFormURL_fullChain_invalidModel_returnsError() {
        stub(condition: isHost("www.test.org")) { request in
            return OHHTTPStubsResponse(data: TestHelper.validDataWithOptional(),
                                       statusCode: 200,
                                       headers: ["Content-Type":"application/json"])
        }
        
        let expectation = self.expectation(description: "Network")
        
        let url = "http://www.test.org"
        let parameters = ["key1":"value1", "key2": "value2"]
        let body = TestHelper.validBody()
        let header = ["Content-Type":"application/json"]
        
        SwiftyJSONFetch().body(body).header(header).parameters(parameters).method(.post).fetch(fromURLString: url, forType: InvalidModel.self) { (response, error) in
            XCTAssertNil(response)
            XCTAssertEqual(error!.errorDescription, "The data couldn’t be read because it is missing.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.2)
    }
    
    
    //MARK: - chain tests
    func test_method_setsMethod() {
        let swifty = SwiftyJSONFetch().method(.patch)
        XCTAssertEqual(swifty.returnMethod(), "PATCH")
    }
    
    func test_parameters_validParameters_setsParameter() {
        let swifty = SwiftyJSONFetch().parameters(["key1":"value1", "key2": "value2"])
        XCTAssertEqual(swifty.returnParameters(), ["key1":"value1", "key2": "value2"])
    }
    
    func test_parameters_emptyParameters_setsParameter() {
        let swifty = SwiftyJSONFetch().parameters([:])
        XCTAssertEqual(swifty.returnParameters(), [:])
    }
    
    func test_header_validHeader_setsHeader() {
        let swifty = SwiftyJSONFetch().header(["key1":"value1", "key2": "value2"])
        XCTAssertEqual(swifty.returnHeader(), ["key1":"value1", "key2": "value2"])
    }
    
    func test_header_emptyHeader_setsHeader() {
        let swifty = SwiftyJSONFetch().header([:])
        XCTAssertEqual(swifty.returnHeader(), [:])
    }
    
    func test_header_validData_setsBody() {
        let swifty = SwiftyJSONFetch().body(TestHelper.validBody())
        XCTAssertEqual(swifty.returnBody(), TestHelper.validBody())
    }
    
    func test_header_emptyData_setsBody() {
        let swifty = SwiftyJSONFetch().body(Data())
        XCTAssertEqual(swifty.returnBody()!.count, 0)
    }
    
    
    //MARK: - fetch from file
    func test_fetch_validFile_returnsValidModel() {
        
        let expectation = self.expectation(description: "File")
        
        let modelToCompare = ValidModel(id: "testId", number: 123.4, optionalNumber: 42)
        
        SwiftyJSONFetch().fetch(fromFileName: "validResponse", forBundle: Bundle(for: type(of: self)), forType: ValidModel.self) { (response, error) in
            
            XCTAssertEqual(response, modelToCompare)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetch_invalidFile_returnsError() {
        
        let expectation = self.expectation(description: "File")
        
        SwiftyJSONFetch().fetch(fromFileName: "invalidResponse", forBundle: Bundle(for: type(of: self)), forType: ValidModel.self) { (response, error) in
            
            XCTAssertEqual(error!.errorDescription, "The data couldn’t be read because it isn’t in the correct format.")
            XCTAssertNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_fetch_fileNotFound_returnsError() {
        
        let expectation = self.expectation(description: "File")
        
        SwiftyJSONFetch().fetch(fromFileName: "someWeirdName", forBundle: Bundle(for: type(of: self)), forType: ValidModel.self) { (response, error) in
            
            XCTAssertEqual(error!.errorDescription, "File not found for name: someWeirdName")
            XCTAssertNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var isNilResponse = false
    var isEmptyResponse = false
    
    func fetch(url: URL, parameters: [String : String], bodyData: Data?, method: HTTPMethod, header: [String : String], completion: @escaping (Data?, DataError?) -> ()) {
        if isNilResponse {
            completion(nil, nil)
        } else if isEmptyResponse {
            completion(Data(), nil)
        }
    }
}

fileprivate extension SwiftyJSONFetch {
    func returnMethod() -> String {
        return self.method.rawValue
    }
    
    func returnParameters() -> [String:String]? {
        return self.parameter
    }
    
    func returnHeader() -> [String:String]? {
        return self.header
    }
    
    func returnBody() -> Data? {
        return self.body
    }
}
