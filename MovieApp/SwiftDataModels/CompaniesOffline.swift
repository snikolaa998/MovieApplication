//
//  CompaniesOffline.swift
//  MovieApp
//
//  Created by Nikola Savic on 25.5.24..
//

import Foundation
import SwiftData

@Model
class CompaniesOffline {
    @Attribute(.unique)
    var id: Int
    var logoPath: String?
    
    init(id: Int, logoPath: String?) {
        self.id = id
        self.logoPath = logoPath
    }
}
