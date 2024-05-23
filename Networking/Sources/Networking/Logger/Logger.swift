//
//  Logger.swift
//  
//
//  Created by Nikola Savic on 21.5.24..
//

import Combine
import Foundation

public protocol Logger {
  func log(request: URLRequest)
  func log(response: URLResponse, data: Data)
}

public class ConsoleLogger: Logger {
  public func log(request: URLRequest) {
    print(request.contents(formatted: true))
  }
  public func log(response: URLResponse, data: Data) {
    print(response.contents(of: data, formatted: false))
  }
  public init() {}
}

public enum LogMode {
  case none
  case logger(Logger)
    
  public static let console: Self = .logger(ConsoleLogger())
  var logger: Logger? {
    guard case let .logger(logger) = self else {
      return nil
    }
    return logger
  }
}

extension URLRequest {
  func curl(formatted: Bool = false) -> String {
    var data = ""
    let complement = formatted ? "\\\n" : ""
    let method = "-X \(httpMethod ?? "GET") \(complement)"
    let url = "\"" + (url?.absoluteString ?? "") + "\""
    var header = ""
      
    if let httpHeaders = allHTTPHeaderFields?.sorted(by: { element1, element2 -> Bool in
      element1.key > element2.key
    }) {
      for (key, value) in httpHeaders {
        header += "-H \"\(key): \(value)\" \(complement)"
      }
    }
      
    if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
      data = "-d \'\(bodyString)\' \(complement)"
    }
      
    let command = "curl -i " + complement + method + header + data + url
      
    return command
  }
    
  func contents(formatted: Bool = false) -> String {
    formatted ? formattedContents() : notFormattedContents()
  }
    
  private func formattedContents() -> String {
    "-------- Request created -------- \n\(curl(formatted: true))"
  }
    
  private func notFormattedContents() -> String {
    "-------- Request created -------- \(curl(formatted: false))"
  }
    
}

extension URLResponse {
  /// Returns http status code if response is from HTTP protocol source.
  var httpStatusCode: Int {
    (self as? HTTPURLResponse)?.statusCode ?? -1
  }
    
  /// Returns contents of the response as string.
  func contents(of data: Data?, formatted: Bool = true) -> String {
    formatted ? formattedContents(with: data, statusCode: httpStatusCode) : notFormattedContents(with: data, statusCode: httpStatusCode)
  }
    
  /// Returns contents as formatted string.
  private func formattedContents(with data: Data?, statusCode: Int) -> String {
    """
    -------- Response received --------
    Status code: \(statusCode)
    Path: \(url?.absoluteString ?? "")
    Body: \(data?.prettyPrintedJSONString ?? "")
    \n\n
    """
  }
    
  /// Returns contents as not formatted string (in single line).
  private func notFormattedContents(with data: Data?, statusCode: Int) -> String {
    "-------- Response received -------- Status code: \(statusCode) Path: \(url?.absoluteString ?? "") Body: \(data?.jsonString ?? "")"
  }
}

extension Data {
  /// Produces pretty printed from data from json string
  var prettyPrintedJSONString: CustomStringConvertible {
    let dictionary = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any] ?? [:]
    return dictionary ?? [:]
  }
    
  /// Produces non formatted json string.
  var jsonString: CustomStringConvertible {
    String(data: self, encoding: .utf8) ?? "N/A"
  }
    
}

extension Publisher where Output == URLRequest {
  func logRequest(with logger: Logger?) -> Publishers.HandleEvents<Self> {
    handleEvents(receiveOutput: { logger?.log(request: $0) })
  }
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
  func logResponse(with logger: Logger?) -> Publishers.HandleEvents<Self> {
    handleEvents(receiveOutput: { logger?.log(response: $0.response, data: $0.data) })
  }
}
