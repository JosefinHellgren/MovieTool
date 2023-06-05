//
//  InfoView.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-29.
//

import SwiftUI

struct InfoView: View {
    
    
    @ObservedObject private var infoVm: InfoViewModel
    
    
    var movie : Movie
    
    @State private var isFavorite = false
    @EnvironmentObject private var favoriteMoviesManager: FavoriteMoviesManager
    @State var showTrailer = false
    
    
    
    
    init(movie: Movie) {
        self.movie = movie
        _isFavorite = State(initialValue: FavoriteMoviesManager.isMovieFavorite(movie))
        self.infoVm = InfoViewModel()
       
        
    }
    
    var genreNames: [String] {
        movie.genreIds.compactMap { genreId in
            infoVm.finalGenres.first { $0.id == genreId }?.name
        }
    }
    
    
    
    
    
    
    var body: some View {
        ScrollView{
            VStack{
                
                HStack{
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Button(action: {
                        
                        
                        isFavorite.toggle()
                        if isFavorite {
                            // Save movie as favorite
                            FavoriteMoviesManager.saveFavoriteMovie(movie)
                        } else {
                            // Remove movie from favorites
                            FavoriteMoviesManager.removeFavoriteMovie(withID: movie.id)
                        }
                    }) {
                        
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
                
                HStack{
                    if let posterURL = movie.posterURL {
                        AsyncImage(url: posterURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 300)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("No Image Available")
                    }
                    VStack{
                        Text(movie.releaseDate ?? "cant find release date")
                        VStack{
                            ForEach(genreNames, id: \.self) { genreName in
                                Text(genreName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        
                        Text(movie.originalLanguage)
                    }
                    
                }
                Text(movie.overview)
                    .font(.body)
                Text("Trailer")
                    .font(.title)
                if let firstTrailer = infoVm.trailers.first {
                    
                    WebView(url: URL(string: "https://www.youtube.com/embed/\(firstTrailer.key)")!)
                        .frame(width: 300, height: 200)
                    
                    
                } else {
                    Text("Loading trailer")
                }
                
                Text("Cast:")
                    .font(.title)
                Spacer()
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(infoVm.cast, id: \.id) { actor in
                        Text(actor.name)
                        
                    }
                }
                
                
                
                
                
                
            }
            
        }.onAppear{
            infoVm.fetchTrailers(movie: movie)
            infoVm.fetchActors(for: movie.id)
            infoVm.fetchGenres()
            
            
        }
    }
}
