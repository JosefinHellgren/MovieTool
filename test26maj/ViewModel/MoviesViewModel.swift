//
//  MovieModel.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-26.
//

import Foundation


final class MoviesViewModel : ObservableObject{
    var apiKey = "305f99214975faee28a0f129881c6ec9"
    var baseURL =  "https://api.themoviedb.org/3/"
    var trendingurl = "trending/movie/week?api_key="
    
    
    @Published var topRatedMovies: [Movie] = []
    @Published var nowPlayingMovies: [Movie] = []
    @Published var trending : [Movie] = []
    @Published var movies : [Movie] = []
    @Published var popularMovies : [Movie] = []
    @Published var searchQuery : String = ""
    @Published var trailers : [Trailer] = []
    @Published var selectedTab = 0
    @Published var genres : [Genre] = []
    
   
    
    
    
    
    var filteredMovies : [Movie]{
        if searchQuery.isEmpty{
            return topRatedMovies
        }else{
            return topRatedMovies.filter{$0.title.lowercased().contains(searchQuery.lowercased())}
        }
        
    }
    
    
    enum MovieCategory: String {
        case nowPlaying
        case topRated
        case popular
        case trending
        
    }
    
    func fetchMovies(for category: MovieCategory) {
        var apiUrl = "\(baseURL)\(apiKey)"
        
        switch category {
        case .nowPlaying:
            apiUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=305f99214975faee28a0f129881c6ec9&language=en-US&region=SE&page=1"
        case .topRated:
            apiUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=305f99214975faee28a0f129881c6ec9&language=en-US&region=SE&page=1"
        case .popular:
            apiUrl =
            "https://api.themoviedb.org/3/movie/popular?api_key=305f99214975faee28a0f129881c6ec9&language=en-US&region=SE&page=1"
        case .trending:
            apiUrl =
            "https://api.themoviedb.org/3/trending/movie/week?api_key=305f99214975faee28a0f129881c6ec9&language=en-US&region=SE&page=1"
            
        }
        
        if let url = URL(string: apiUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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
                    let response = try decoder.decode(MovieResponse.self, from: data)
                    let movies = response.results
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        switch category {
                        case .nowPlaying:
                            self?.nowPlayingMovies = movies
                        case .topRated:
                            self?.topRatedMovies = movies
                        case .popular:
                            self?.popularMovies = movies
                        case .trending:
                            self?.trending = movies
                        }
                        
                        
                        
                        
                        
                        print("Fetched \(movies.count) movies")
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        } else {
            print("Invalid URL")
        }
    }
    
    
    func fetchNowPlayingMovies() {
        fetchMovies(for: .nowPlaying)
    }
    
    func fetchTopRatedMovies() {
        fetchMovies(for: .topRated)
    }
    func fetchPopularMovies (){
        fetchMovies(for: .popular)
    }
    
    func fetchTrendingMovies(){
        fetchMovies(for: .trending)
    }
    
    
    
    
    struct MovieResponse: Decodable {
        let results: [Movie]
    }
    
    
}
