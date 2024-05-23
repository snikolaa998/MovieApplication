//
//  File.swift
//  
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public protocol MovieAPIRequest {
  associatedtype ResponseType: Decodable
  var cachePolicy: NSURLRequest.CachePolicy { get }
  var endpoint: String { get }
  var queryItems: [URLQueryItem] { get }
  func generateURLRequest() -> URLRequest?
  var authorization: Authorization? { get set }
}

public extension MovieAPIRequest {
  func createURL() -> URL? {
    guard let baseUrl = URL(string: APIConstants.baseURL) else {
      return nil
    }
      
      var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
      components?.path += endpoint
      if !queryItems.isEmpty {
          components?.queryItems = queryItems
      }
      guard let validComponents = components, let url = validComponents.url else {
          return nil
      }
      return url
  }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }

    var queryItems: [URLQueryItem] {
        return []
    }

    var authorization: Authorization? {
        get { return nil }
        set { _ = newValue }
    }
}
