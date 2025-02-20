//
//  NetworkManager.swift
//  Potioneer
//
//  Created by Thavorn Kamolsin on 2/11/2567 BE.
//

import UIKit
import Foundation

class NetworkManager {
    
    let timeoutIntervalForRequest: Double = 60.0
    let timeoutIntervalForResource: Double = 60.0
    
    public func request(_ requesMeta:BaseRequestMeta, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        var httpRequest: URLRequest
        var session: URLSession
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        session = URLSession(configuration: configuration)
        httpRequest = URLRequest(url: URL(string: requesMeta.urlRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)
        httpRequest.httpMethod = requesMeta.method.rawValue
        httpRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        for value in requesMeta.header {
            for dicDataValue in value.enumerated() {
                httpRequest.setValue(dicDataValue.element.value as? String, forHTTPHeaderField: dicDataValue.element.key)
            }
        }
        switch requesMeta.endcoding {
        case .jsonEncoding:
            let jsonData = try? JSONSerialization.data(withJSONObject: requesMeta.params)
            httpRequest.httpBody = jsonData
        case .urlEncoding:
            break
        }
        let task = session.dataTask(with: httpRequest) { (data, response, error) in
            completion(data, response, error)
        }
        task.resume()
    }
    
}
