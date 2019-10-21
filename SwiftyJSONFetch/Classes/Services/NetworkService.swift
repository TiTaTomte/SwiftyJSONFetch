//
//  NetworkService.swift
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


public protocol NetworkServiceProtocol {
    func fetch(url: URL, parameters: [String: String], bodyData: Data?, method: HTTPMethod, header: [String:String], completion: @escaping (_ reponse: Data?, _ error: DataError?) -> ())
}

public class NetworkService: NetworkServiceProtocol {
    
    fileprivate var urlService: URLServiceProtocol
    
    public init(urlService: URLServiceProtocol = URLService()) {
        self.urlService = urlService
    }
    
    public func fetch(url: URL, parameters: [String: String], bodyData: Data?, method: HTTPMethod, header: [String:String], completion: @escaping (_ reponse: Data?, _ error: DataError?) -> ()) {
        
        var request = URLRequest(url: urlService.urlWithParameters(url: url, parameters: parameters))
        request.allHTTPHeaderFields = header
        request.httpBody = bodyData
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            var dataError: DataError? = nil
            if let error = error {
                dataError = DataError.withMessage(error.localizedDescription)
            }
            completion(data, dataError)
        }

        task.resume()
    }
}
