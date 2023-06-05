//
//  HomeScreen.swift
//  test26maj
//
//  Created by josefin hellgren on 2023-05-29.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var vm = MoviesViewModel()
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.filteredMovies) { movie in
                    VStack {
                        if let posterURL = movie.posterURL {
                            AsyncImage(url: posterURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Text("No Image Available")
                        }
                        NavigationLink(destination: InfoView(movie: movie)) {
                                         Text(movie.title)
                                }
                    }
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
