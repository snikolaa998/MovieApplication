//
//  MovieDetailsScreen.swift
//  MovieApp
//
//  Created by Nikola Savic on 23.5.24..
//

import SwiftUI
import CachedAsyncImage

struct MovieDetailsScreen: View {
    @StateObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground)
        .loadingView(isLoading: viewModel.state.isLoading)
        .task {
            viewModel.dispatch(.getDetails)
        }
    }
    
    private var content: some View {
        VStack {
            header
            
            ScrollView {
                VStack(alignment: .leading, spacing: .zero) {
                    movieHeader
                        .padding(.top, 24)
                    
                    ratingAndImdb
                    
                    detailCardView(
                        section: .init(
                            title: "Box office",
                            rows: [
                                .init(
                                    title: "Budget",
                                    value: (viewModel.state.movie?.budget ?? 0).formatted(.currency(code: "USD"))
                                ),
                                .init(
                                    title: "Revenue",
                                    value: (viewModel.state.movie?.revenue ?? 0).formatted(.currency(code: "USD"))
                                )
                            ]
                        )
                    )
                    
                    detailCardView(
                        section: .init(
                            title: "Details",
                            rows: [
                                .init(
                                    title: "Release date",
                                    value: "\(viewModel.state.movie?.releaseDate ?? "N/A")"
                                ),
                                .init(
                                    title: "Popularity",
                                    value: "\(viewModel.state.movie?.popularity ?? 0.0)"
                                )
                            ]
                        )
                    )
                    
                    tehcnialView
                    
                    productionCompanies
                    
                    Spacer()
                }
            }
        }
    }
    
    private var tehcnialView: some View {
        VStack(spacing: 6) {
            rowHeader(title: "Technical specs")
            
            HStack(spacing: 6) {
                Text("Runtime: ")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
                
                Text("\(viewModel.state.movie?.runtime ?? 0) min")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                
                Image(.iconClock)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .roundedRectangleBackground(
            backgroundColor: Color.backgroundBlack,
            cornerRadius: 0,
            borderColor: .clear,
            borderWidth: 0
        )
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
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
                
                Spacer()
            }
        }
        .overlay(alignment: .center) {
            Text("Movie details")
                .foregroundStyle(.white)
                .font(.system(size: 24))
        }
        .overlay(alignment: .trailing) {
            if viewModel.state.movie?.title != nil {
                Image(viewModel.state.isFavorite ? .icHeartFill : .icHeartEmpty)
                    .resizable()
                    .frame(width: 22, height: 20)
                    .padding(.trailing, 24)
                    .onTapGesture {
                        viewModel.dispatch(.saveFavoriteMovie(viewModel.state.movie))
                    }
            }
        }
        .padding(.bottom, 16)
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private var movieHeader: some View {
        VStack(spacing: 8) {
            Text(viewModel.state.movie?.title ?? "")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 10) {
                Text("\(viewModel.state.movie?.releaseDate ?? "")")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                
                Text("\(viewModel.state.movie?.runtime ?? 0) min")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            AsyncImage(url: URL(string: "\(Configuration.posterBaseUrl)\(viewModel.state.movie?.posterPath ?? "")")) { phase in
                if let image = phase.image {
                    content(image: image)
                } else if phase.error != nil {
                    Rectangle()
                        .frame(height: 162)
                        .foregroundStyle(Color.darkWhite)
                } else {
                    ProgressView()
                        .frame(height: 162)
                }
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    if let genres = viewModel.state.movie?.genres {
                        ForEach(genres, id: \.id) {
                            Text("\($0.name ?? "")")
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                                .padding(8)
                                .roundedRectangleBackground(
                                    backgroundColor: .clear,
                                    cornerRadius: 20,
                                    borderColor: Color.white.opacity(0.5),
                                    borderWidth: 1
                                )
                        }
                        
                    }
                    Spacer()
                }
            }
            
            Text("**Description:** \(viewModel.state.movie?.overview ?? "")")
                .font(.system(size: 14))
                .foregroundStyle(.white)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
    
    private func content(image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .roundedRectangleBackground(
                backgroundColor: .clear,
                cornerRadius: 8,
                borderColor: .clear,
                borderWidth: 0
            )
    }
    
    private var ratingAndImdb: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 4) {
                Image(.iconStar)
                
                Text("**\(String(format:"%.2f", viewModel.state.movie?.voteAverage ?? 0))** / 10")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                
                Text("\(viewModel.state.movie?.voteCount ?? 0) reviewers")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Button(
                action: {
                    guard let imdbId = viewModel.state.movie?.imdbId,
                          let url = URL(string: "https://www.imdb.com/title/\(imdbId)")
                    else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }, label: {
                    Image(.imdb)
                }
            )
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .roundedRectangleBackground(
            backgroundColor: Color.backgroundBlack,
            cornerRadius: 0,
            borderColor: .clear,
            borderWidth: 0
        )
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
    
    private func detailCardView(section: MovieDetailsSection) -> some View {
        VStack(spacing: 10) {
            rowHeader(title: section.title)
            VStack(spacing: 6) {
                ForEach(section.rows, id: \.title) {
                    rowContent(subtitle: $0.title, information: $0.value)
                }
            }
        }
        .padding(16)
        .roundedRectangleBackground(
            backgroundColor: Color.backgroundBlack,
            cornerRadius: 0,
            borderColor: .clear,
            borderWidth: 0
        )
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
    
    private func rowHeader(title: String) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                Color.themeYellow
                    .frame(width: 2, height: 21)
                
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func rowContent(subtitle: String, information: String) -> some View {
        HStack(spacing: 6) {
            Text("\(subtitle): ")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
            
            Text(information)
                .font(.system(size: 16))
                .foregroundStyle(.white)
            
            Spacer()
        }
    }
    
    private var productionCompanies: some View {
        VStack(spacing: 6) {
            rowHeader(title: "Production companies")
            
            ScrollView(.horizontal) {
                HStack(spacing: 6) {
                    if let productionCompanies = viewModel.state.movie?.productionCompanies {
                        ForEach(productionCompanies, id: \.id) {
                            CachedAsyncImage(url: URL(string: "\(Configuration.posterBaseUrl)\($0.logoPath ?? "")")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .roundedRectangleBackground(
                                            backgroundColor: .white,
                                            cornerRadius: 4,
                                            borderColor: 0,
                                            borderWidth: 0
                                        )
                                } else if phase.error != nil {
                                    Rectangle()
                                        .frame(height: 44)
                                        .foregroundStyle(Color.darkWhite)
                                } else {
                                    ProgressView()
                                        .controlSize(.regular)
                                        .frame(height: 44)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .roundedRectangleBackground(
            backgroundColor: Color.backgroundBlack,
            cornerRadius: 0,
            borderColor: .clear,
            borderWidth: 0
        )
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
}

struct MovieDetailsSection {
    let title: String
    let rows: [MovieDetailsRow]
}

struct MovieDetailsRow {
    let title: String
    let value: String
}
