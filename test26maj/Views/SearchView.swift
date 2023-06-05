//
//  SearchView.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-29.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: MoviesViewModel
    
    var body: some View {
        VStack{
            TextField("Search", text: $vm.searchQuery)
            
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        Spacer()
                    }
                )
                .padding(.horizontal)
            
            if vm.filteredMovies.isEmpty {
                Text("No movies found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView{
                   
                    MoviesGridView(movies: vm.filteredMovies)
                }
            }
        }
        
    }
}

struct MoviesGridView: View {
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
            Button(action: {
                isSortingAscending.toggle()
            }) {
                Text(isSortingAscending ? "Sort by top ratings" : "sort by lowest ratings")
                    .background(Color.black)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20.0)
            }
           
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
                                
                            } placeholder: {
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



