//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Nikola Savic on 23.5.24..
//

import SwiftUI
import CachedAsyncImage
import Domain

struct MovieRowView: View {
    private var movie: MovieEntity
    
    init(movie: MovieEntity) {
        self.movie = movie
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                if let imagePath = movie.posterPath {
                    image(url: URL(string: "https:image.tmdb.org/t/p/w185\(imagePath)"))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 8) {
                        Image(.iconStar)
                        Text("**\(String(format:"%.2f", movie.voteAverage ?? 0))**/10")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .overlay(
            VStack {
                Spacer()
                Color.white.frame(height: 0.5)
            }.padding(.horizontal, 16)
        )
    }
    
    private func image(url: URL?) -> some View {
        CachedAsyncImage(url: url) { phase in
            if let image = phase.image {
                content(image: image)
            } else if phase.error != nil {
                Rectangle()
                    .frame(width: 84, height: 84)
                    .foregroundStyle(Color.darkWhite)
                    .roundedRectangleBackground(
                        backgroundColor: .clear,
                        cornerRadius: 8,
                        borderColor: .clear,
                        borderWidth: 0
                    )
            } else {
                ProgressView()
                    .controlSize(.regular)
                    .tint(.white)
                    .frame(width: 84, height: 84)
            }
        }
    }
    
    private func content(image: Image) -> some View {
        image
            .resizable()
            .frame(width: 83, height: 77)
            .scaledToFill()
            .roundedRectangleBackground(
                backgroundColor: .clear,
                cornerRadius: 8,
                borderColor: .clear,
                borderWidth: 0
            )
    }
}
