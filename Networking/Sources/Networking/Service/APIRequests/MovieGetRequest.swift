//
//  MovieGetAPIRequest.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public protocol MovieGetAPIRequest: MovieAPIRequest {}

public extension MovieGetAPIRequest {
    func generateURLRequest() -> URLRequest? {
        guard let url = createURL() else {
            return nil
        }
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 60)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        if let authentication = authorization {
            request.setValue("Bearer \(authentication.apiKey)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
