//
//  CompaniesEntity+Mapping.swift
//  
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation
import Domain
import Networking

extension CompaniesEntityDTO {
    func toCompaniesEntity() -> CompaniesEntity {
        return .init(
            id: id,
            logoPath: logoPath
        )
    }
}
