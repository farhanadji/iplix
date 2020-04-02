//
//  NetworkManager.swift
//  iplix
//
//  Created by Farhan Adji on 02/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    let api_key = "011476f22113ee2ae9d19f4d511997bc"
    let popularMovieURL = "https://api.themoviedb.org/3/movie/popular?api_key=011476f22113ee2ae9d19f4d511997bc&language=en-US"
    let posterURL = "https://image.tmdb.org/t/p/w185"
    let genreURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=011476f22113ee2ae9d19f4d511997bc&language=en-US"
    
    func getPopularMovies(competion: @escaping ([Movies]) -> ()) {
        AF.request(popularMovieURL, method: .get).responseDecodable(of: Results.self) { response in
            guard let movies = response.value?.results else { return }
//            print(movies)
            competion(movies)
        }
    }
    
    func getGenres(competion: @escaping ([Genres]) -> ()) {
        AF.request(genreURL, method: .get).responseDecodable(of: ResultGenres.self) { response in
                guard let genres = response.value?.genres else { return }
    //            print(movies)
                competion(genres)
            }
        }
    
}
