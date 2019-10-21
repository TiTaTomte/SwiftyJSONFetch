//
//  URLServiceTests.swift
//  SwiftyJSONFetch_Tests
//
//  Created by Thomas Marien on 20.10.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftyJSONFetch

class URLServiceTests: XCTestCase {

    func test_urlWithParameters_validParameters_returnsValidURL() {
        let service = URLService()
        let parameters = [
            "key1":"param1",
            "key2":"param2"
        ]
        
        let url = service.urlWithParameters(url: URL(string: "http://www.test.org")!, parameters: parameters)
        
        XCTAssertEqual(url, URL(string: "http://www.test.org?key1=param1&key2=param2")!)
    }
    
    func test_urlWithParameters_emptyParameters_returnsValidURL() {
        let service = URLService()
        let parameters: [String:String] = [:]
        
        let url = service.urlWithParameters(url: URL(string: "http://www.test.org")!, parameters: parameters)
        
        XCTAssertEqual(url, URL(string: "http://www.test.org"))
    }
}
