//
//  File.swift
//  
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public enum APIError: Error, Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.network(let lhsError), .network(let rhsError)):
            return self.areEqual(lhsError, rhsError)
        case (.decoding(let lhsError), .decoding(let rhsError)):
            return self.areEqual(lhsError, rhsError)
        case (.encoding(let lhsError), .encoding(let rhsError)):
            return self.areEqual(lhsError, rhsError)
        case (.error(let lhsError), .error(let rhsError)):
            return self.areEqual(lhsError, rhsError)
        default: return false
        }
    }

    public static func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
        return lhs.reflectedString == rhs.reflectedString
    }

    case network(error: Error)
    case decoding(error: Error)
    case encoding(error: Error)
    case error(error: Error)
    case notFound
    case errorWithMessage(String)
}

public extension Error {
    var reflectedString: String {
        return String(reflecting: self)
    }
}

public extension APIError {
    var localizedDescription: String {
        switch self {
        case .network(let error), .decoding(let error), .encoding(let error), .error(let error):
            return error.localizedDescription
        case .notFound:
            return "Route not found"
        case .errorWithMessage(let errorMessageFromBE):
            return errorMessageFromBE
        }
    }
}

public struct APIErrorData: Decodable, Error {
    public let message: String
    public let role: String
}
