//
//  Favourites.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-29.
//

import SwiftUI

struct Favourites: View {
    @EnvironmentObject private var favoriteMoviesManager: FavoriteMoviesManager
    @State private var favoriteMovies: [Movie] = []
    var body: some View {
        
        
        VStack{
            ScrollView{
                
                ForEach(favoriteMovies) { movie in
                    HStack{
                        NavigationLink(destination: InfoView(movie: movie)){
                            if let posterURL = movie.posterURL {
                                AsyncImage(url: posterURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 80, alignment: .center)
                                        .cornerRadius(10.0)
                                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Text("No Image Available")
                            }
                            
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        Image(systemName: "xmark.circle")
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .onTapGesture {
                                removeFavoriteMovie(movie)
                            }
                    }
                }
            }
        }.onAppear{
            updateFavoriteMovies()
        }
    }
    private func updateFavoriteMovies() {
        favoriteMovies = FavoriteMoviesManager.getFavoriteMovies()
        print(favoriteMovies)
    }
    
    private func removeFavoriteMovie(_ movie: Movie) {
        FavoriteMoviesManager.removeFavoriteMovie(withID: movie.id)
        updateFavoriteMovies()
    }
}

struct Favourites_Previews: PreviewProvider {
    static var previews: some View {
        Favourites()
    }
}
