//
//  FavoriteMoviesScreen.swift
//  MovieApp
//
//  Created by Nikola Savic on 25.5.24..
//

import SwiftUI

struct FavoriteMoviesScreen: View {
    @StateObject var viewModel: FavoriteMoviesViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            header
                .padding(.top, 16)
            
            moviesList
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.primaryBackground)
        .task {
            viewModel.dispatch(.loadMovies)
        }
    }
    
    private var header: some View {
        HStack(spacing: .zero) {
            Button {
                viewModel.dispatch(.dismiss)
            } label: {
                Image(.icArrowBack)
                    .renderingMode(.template)
                    .tint(.white)
                    .padding(.leading, 24)
            }
            Spacer()
        }
        .overlay(alignment: .center) {
            Text("Favorite Movies")
                .foregroundStyle(.white)
                .font(.system(size: 24))
        }
    }
    
    @ViewBuilder
    private var moviesList: some View {
        if viewModel.state.movies.isEmpty {
            Text("No favorite movies found.")
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .padding(.top, 16)
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.state.movies.enumerated()), id: \.element.id) {
                        index,
                        movie in
                        MovieRowView(
                            movie: .init(
                                id: movie.id,
                                posterPath: movie.posterPath,
                                title: movie.title,
                                budget: movie.budget,
                                releaseDate: movie.releaseDate,
                                runtime: movie.runtime,
                                genres: [],
                                voteAverage: movie.voteAverage,
                                voteCount: movie.voteCount,
                                revenue: movie.revenue,
                                overview: movie.overview,
                                popularity: movie.popularity,
                                productionCompanies: [],
                                imdbId: movie.imdbId
                            )
                        )
                        .onTapGesture {
                            viewModel.dispatch(.onItemTapped(movie.id))
                        }
                    }
                }
            }
        }
    }
}
