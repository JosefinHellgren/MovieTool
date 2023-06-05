//
//  ContentView.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-26.
//

import SwiftUI
import CoreData
import Foundation


struct ContentView: View {
    @StateObject private var vm = MoviesViewModel()
    @State private var selectedTab = 0
    @StateObject private var favoriteMoviesManager = FavoriteMoviesManager()
    
    var body: some View {
        
        NavigationView{
            ZStack{
            TabView(selection: $selectedTab){
                VStack{
                    ScrollView{
                     
                        CategoryView(title: "Now Playing", movies: vm.nowPlayingMovies)
                        ContentMoviesGridView(movies: vm.topRatedMovies)
                        CategoryView(title: "Top Rated Movies Imdb", movies: vm.topRatedMovies)
                        CategoryView(title: "Popular", movies: vm.popularMovies)
                        CategoryView(title: "Trending", movies: vm.trending)
                    }
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                
                SearchView(vm: vm)
                
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                Favourites()
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                    .tag(2)
                
                
            }
            .navigationTitle("Movies")
            .environmentObject(favoriteMoviesManager)
            .environmentObject(vm)
            .onAppear{
                
                if vm.popularMovies.isEmpty {
                                vm.fetchPopularMovies()
                            }
                            if vm.trending.isEmpty {
                                vm.fetchTrendingMovies()
                            }
                            if vm.topRatedMovies.isEmpty {
                                vm.fetchTopRatedMovies()
                            }
                            if vm.nowPlayingMovies.isEmpty {
                                vm.fetchNowPlayingMovies()
                            }
              
                
            }
        }
        }
    }
}
struct ContentMoviesGridView: View {
    let movies: [Movie]
    @State private var isSortingAscending = true
    var sortedMovies: [Movie] {
        if isSortingAscending {
            return movies.sorted { $0.voteAverage < $1.voteAverage }
        } else {
            return movies.sorted { $0.voteAverage > $1.voteAverage }
        }
    }
    
    
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        HStack {
            Spacer()
            Text("Top on Imdb")
                .font(.title)
                .fontWeight(.bold)
            Button(action: {
                isSortingAscending.toggle()
            }) {
                Text(isSortingAscending ? "Sort by top ratings" : "Sort by lowest ratings")
                   
                            .foregroundColor(.white)
                          
            }.buttonStyle(BorderedButtonStyle())
                .background(Color.black)
                .cornerRadius(13.0)
              
          
           
        }
        
        LazyVGrid(columns: gridLayout, spacing: 10) {
            ForEach(sortedMovies) { movie in
                        let itemID = UUID()
                VStack {
                    NavigationLink(destination: InfoView(movie: movie)) {
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10.0)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                                
                            }
                            
                            
                        placeholder: {
                                ProgressView()
                            }
                        } else {
                            Text("No Image Available")
                        }
                    }
                    
                    Text(movie.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding()
                        .cornerRadius(10.0)
                        .lineLimit(1)
                    
                    
                }.id(itemID)
            }
        }
        .padding()
    }
}



struct CategoryView: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    
                    ForEach(movies) { movie in
                        NavigationLink(destination: InfoView(movie: movie)){
                            VStack {
                                if let posterURL = movie.posterURL {
                                    AsyncImage(url: posterURL) { image in
                                        image
                                            .resizable()
                                        
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10.0)
                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 200, height: 300)
                                } else {
                                    Text("No Image Available")
                                }
                                
                                Text(movie.title)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.black)
                            }
                        }}
                }
                .padding(.horizontal)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
