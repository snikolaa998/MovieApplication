//
//  MoviesListScreen.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import SwiftUI


struct MoviesListScreen: View {
    @StateObject var viewModel: MoviesListViewModel
    @FocusState private var isSearchInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            header
            separator
            searchInput
            moviesList
            Spacer()
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.primaryBackground)
        .loadingView(isLoading: viewModel.state.isLoading)
        .toastView(toast: $viewModel.state.toast)
        .task {
            viewModel.dispatch(.onAppear)
        }
    }
    
    private var separator: some View {
        Color.white.opacity(0.8)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }
    
    private var header: some View {
        HStack(spacing: .zero) {
            Spacer()
            
            Text("Movies List")
                .foregroundStyle(.white)
                .font(.system(size: 24))
            
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Image(.icHeartFill)
                .resizable()
                .frame(width: 22, height: 20)
                .padding(.trailing, 24)
                .onTapGesture {
                    viewModel.dispatch(.onFavoritesTapped)
                }
        }
    }
    
    @ViewBuilder
    private var moviesList: some View {
        if viewModel.state.movies.isEmpty {
            Text("No movies found for given term.")
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .padding(.top, 16)
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.state.movies.enumerated()), id: \.element.id) { index, movie in
                        MovieRowView(movie: movie)
                            .onTapGesture {
                                viewModel.dispatch(.onItemTapped(movie.id))
                            }
                            .task {
                                viewModel.fetchMoreIfNeeded(at: index)
                            }
                    }
                }
            }
        }
    }
    
    private var searchInput: some View {
        HStack(spacing: 8) {
            searchInputContent
            if isSearchInputFocused {
                cancelSearchButton
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var searchInputContent: some View {
        HStack(spacing: .zero) {
            Image(.icSearch)
                .padding(.leading, 10)

            searchInputField

            if isSearchInputFocused {
                clearSearchQueryButton
            }
        }
        .frame(height: 40)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var searchInputField: some View {
        TextField(
            "",
            text: $viewModel.searchTerm,
            prompt: Text("Search for a movie").foregroundColor(.gray)
        )
        .focused($isSearchInputFocused)
        .keyboardType(.alphabet)
        .textContentType(.oneTimeCode)
        .autocorrectionDisabled()
        .submitLabel(.go)
        .foregroundStyle(.black)
    }
    
    private var clearSearchQueryButton: some View {
        Button(
            action: {
                viewModel.dispatch(.clearSearchTerm)
            },
            label: {
                Image(systemName: "xmark")
                    .tint(Color.backgroundBlack)
                    .padding(.trailing, 8)
            }
        )
    }

    private var cancelSearchButton: some View {
        Button(
            action: {
                isSearchInputFocused = false
                viewModel.dispatch(.clearSearchTerm)
            }, label: {
                Text("Cancel")
                    .foregroundStyle(.white)
            }
        )
    }
}
