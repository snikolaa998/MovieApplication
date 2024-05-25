//
//  CompaniesEntityDTO.swift
//
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation

public struct CompaniesEntityDTO: Decodable {
    public let id: Int
    public let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
    }
}
