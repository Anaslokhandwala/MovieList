//
//  NetworkCustom.swift
//  NetworkCustom
//
//  Created by Mac on 16/05/24.
//

import Foundation

/// Reference to `BoredFramework.default` for quick bootstrapping; Alamofire style!

public class NetworkCustomCalling {
    
    public init() {
        // You can optionally provide any setup code here.
    }
    
    public func request(endpoint: NetworkEndpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlString = endpoint.url.absoluteString
        
        let queryParameter = endpoint.queryItems
        if !queryParameter.isEmpty {
            let queryString = queryParameter.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            urlString += "?\(queryString)"
        }
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "com.example.CustomNetworkSDK", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = endpoint.headers

        if endpoint.method == "POST" {
            if let body = endpoint.body {
                request.httpBody = body
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "com.example.CustomNetworkSDK", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}

public enum NetworkEndpoint {
    case custom(url: URL, method: String, headers: [String: String]?, queryItems: [String: Any]?, body: Data?)
    
    var url: URL {
        switch self {
        case .custom(let url, _, _, _, _):
            return url
        }
    }
    
    var method: String {
        switch self {
        case .custom(_, let method, _, _, _):
            return method
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .custom(_, _, let headers, _, _):
            return headers ?? [:]
        }
    }
    
    var queryItems: [String: Any] {
        switch self {
        case .custom(_, _, _, let queryItems, _):
            return queryItems ?? [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .custom(_, _, _, _, let body):
            return body
        }
    }
}


