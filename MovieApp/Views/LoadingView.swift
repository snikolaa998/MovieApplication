//
//  LoadingView.swift
//  MovieApp
//
//  Created by Nikola Savic on 23.5.24..
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
            }
        }
    }
}

public extension View {
    func loadingView(
        isLoading: Bool
    ) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}

#Preview {
    VStack {
        Spacer()
        Text("Loading View Modifier preview")
        Spacer()
    }
    .loadingView(isLoading: true)
}
