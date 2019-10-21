//
//  SwiftyJSONFetch.swift
//  SwiftyJSONFetch
//
//  Created by Thomas Marien on 16.10.19.
//  
//  MIT License
//  Copyright © 2019 Thomas Marien. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation


public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum DataError: Error {
    case withMessage(String)
    
    public var errorDescription: String? {
        switch self {
        case .withMessage(let message):
            return message
        }
    }
}

public class SwiftyJSONFetch {

    internal var method: HTTPMethod = .get
    internal var parameter: [String:String]?
    internal var header: [String:String]?
    internal var body: Data?
    fileprivate var codingService: CodingProtocol
    fileprivate var networkService: NetworkServiceProtocol
    
    
    init(codingService: CodingProtocol = CodingService(), networkService: NetworkServiceProtocol = NetworkService()) {
        self.codingService = codingService
        self.networkService = networkService
    }
    
    
    //MARK: - Customization
    func method(_ method: HTTPMethod) -> SwiftyJSONFetch {
        self.method = method
        return self
    }
    
    func parameters(_ parameter: [String:String]) -> SwiftyJSONFetch {
        self.parameter = parameter
        return self
    }
    
    func header(_ parameter: [String:String]) -> SwiftyJSONFetch {
        self.header = parameter
        return self
    }
    
    func body(_ data: Data) -> SwiftyJSONFetch {
        self.body = data
        return self
    }
    
    
    //MARK: - Fetching
    func fetch<T: Decodable>(fromURLString urlString: String, forType type: T.Type, _ completion: @escaping (_ response: T?, _ error: DataError?) -> ()) {
        guard let url = URL(string: urlString) else {
            return completion(nil, DataError.withMessage("URL could not be created from string: \(urlString)"))
        }
        
        networkService.fetch(url: url, parameters: parameter ?? [:], bodyData: body, method: method, header: header ?? [:]) { (data, error) in
            guard error == nil else {
                return completion(nil, error)
            }
            
            guard let data = data, data.count > 0 else {
                return completion(nil, DataError.withMessage("No data in response!"))
            }
            
            let decoded = self.codingService.decode(data: data, asType: type)
            guard let responseObject = decoded.decoded else {
                return completion(nil, decoded.error)
            }
            
            completion(responseObject, nil)
        }
    }
    
    func fetch<T: Decodable>(fromFileName fileName: String, forBundle bundle: Bundle = Bundle.main, forType type: T.Type, _ completion: @escaping (_ response: T?, _ error: DataError?) -> ()) {
        
        
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            return completion(nil, DataError.withMessage("File not found for name: \(fileName)"))
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return completion(nil, DataError.withMessage("Couldn't parse Data!"))
        }
        
        let decoded = codingService.decode(data: data, asType: type)
        
        guard let response = decoded.decoded else {
            return completion(nil, decoded.error)
        }
        
        completion(response, nil)
    }
}
