//
//  TrailerViewModel.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-06-01.
//

import Foundation


final class InfoViewModel : ObservableObject{
    
    @Published var trailers : [Trailer] = []
    @Published var finalGenres : [Genre] = []
    @Published var genreNames : [String] = []
    @Published var cast : [Actor] = []
    
    
    struct TrailerResponse : Decodable{
        let results : [Trailer]
        
        
        
    }
    
    
    func fetchGenres() {
        
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=305f99214975faee28a0f129881c6ec9&language=en-US")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let genreResponse = try decoder.decode(GenreResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.finalGenres = genreResponse.genres
                       
                    }
                } catch {
                    print("Error decoding genre data: \(error)")
                }
            }
        }.resume()
    }
    
    struct GenreResponse: Codable {
        let genres: [Genre]
    }
    
    
    
    
    func fetchTrailers ( movie :  Movie ){
        
        let apiTrailerUrl = "https://api.themoviedb.org/3/movie/"
        let movieID = String(movie.id)
        let ending = "/videos?api_key=305f99214975faee28a0f129881c6ec9&language=en-US"
        
        let apiUrl = apiTrailerUrl + movieID + ending
        
        if let url = URL(string: apiUrl) {
            URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else {
                    
                    return
                }
                if String(data: data, encoding: .utf8) != nil {
                  
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                
                
                do {
                    let response = try decoder.decode(TrailerResponse.self, from: data)
                    let trailer = response.results
                    
                    let filteredTrailers = trailer.filter { $0.type == "Trailer" }
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        
                        self.trailers = filteredTrailers
                        
                        
                      
                        
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        } else {
            print("Invalid URL")
        }
        
        
        
        
    }
    
    func fetchActors(for movieId: Int) {
        let apiKey = "305f99214975faee28a0f129881c6ec9"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(apiKey)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let castResponse = try decoder.decode(CastResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            
                            let cast = castResponse.cast
                            self.cast = cast
                            
                            print(cast)
                        }
                    } catch {
                        print("Error decoding cast data: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    
    struct CastResponse: Codable {
        let cast: [Actor]
    }
    
}
