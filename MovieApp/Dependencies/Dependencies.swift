//
//  Dependencies.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

class Dependencies {
    private static var instancesCount = 0
    init() {
        Dependencies.instancesCount += 1
    }
}
