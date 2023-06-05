//
//  FavoriteMoviesManager.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-30.
//

import Foundation


import Foundation
import Combine

class FavoriteMoviesManager : ObservableObject{
    static let favoriteMoviesKey = "FavoriteMoviesKey"
  
    
    static func saveFavoriteMovie(_ movie: Movie) {
        var favoriteMovies = getFavoriteMovies()
        if favoriteMovies.contains(where: { $0.id == movie.id }) {
           
            return
        }
        favoriteMovies.append(movie)
        saveFavoriteMovies(favoriteMovies)
    }
    
    static func removeFavoriteMovie(withID id: Int) {
        var favoriteMovies = getFavoriteMovies()
        favoriteMovies.removeAll(where: { $0.id == id })
        saveFavoriteMovies(favoriteMovies)
    }
    static func isMovieFavorite(_ movie: Movie) -> Bool {
           let favoriteMovies = getFavoriteMovies()
           return favoriteMovies.contains(where: { $0.id == movie.id })
       }
    
    static func getFavoriteMovies() -> [Movie] {
        if let data = UserDefaults.standard.data(forKey: favoriteMoviesKey) {
            do {
                let decoder = JSONDecoder()
                let favoriteMovies = try decoder.decode([Movie].self, from: data)
                return favoriteMovies
            } catch {
                print("Error retrieving favorite movies: \(error)")
            }
        }
        return []
    }
    
    private static func saveFavoriteMovies(_ favoriteMovies: [Movie]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoriteMovies)
            UserDefaults.standard.set(data, forKey: favoriteMoviesKey)
        } catch {
            print("Error saving favorite movies: \(error)")
        }
    }
}
