//
//  SplashScreen.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            
            Text("Splash screen")
                .foregroundStyle(.yellow)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

#Preview {
    SplashScreen()
}
