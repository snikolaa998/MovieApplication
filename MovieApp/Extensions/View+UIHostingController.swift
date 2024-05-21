//
//  View+UIHostingController.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import SwiftUI

extension View {
    var hosted: UIViewController {
        return UIHostingController(rootView: self)
    }
}
