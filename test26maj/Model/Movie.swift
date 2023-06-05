//
//  MovieModel.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-26.
//

import Foundation


struct Movie: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let backDropPath: String?
    let posterPath: String?
    let overview: String
    let releaseDate: String?
    let voteAverage: Double
    let originalLanguage : String
    let genreIds : [Int]
    
    
    
    
    
    var posterURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        return baseURL.appendingPathComponent(posterPath)
    }
    
    var backDropURL: URL? {
        guard let backDropPath = backDropPath else {
            return nil
        }
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        return baseURL.appendingPathComponent(backDropPath)
    }
}




