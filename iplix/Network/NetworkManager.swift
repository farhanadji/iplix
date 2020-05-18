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
    
    var movieURL = "https://api.themoviedb.org/3/movie"
    var parameters: [String: String] = [
        "apiKey": "api_key=011476f22113ee2ae9d19f4d511997bc",
        "language": "language=en-US"
    ]
    let posterURL = "https://image.tmdb.org/t/p/w500"
    let posterOriginalURL = "https://image.tmdb.org/t/p/w500"
    let genreURL = "https://api.themoviedb.org/3/genre/list?api_key=011476f22113ee2ae9d19f4d511997bc&language=en-US"
    let moviePageURL = "https://www.themoviedb.org/movie/"
    let searchMovieURL = "https://api.themoviedb.org/3/search/movie"
    let discoverURL = "https://api.themoviedb.org/3/discover/movie"
    
    func getMovies(typeMovie: String, page: Int = 1, competion: @escaping ([Movie], Int) -> ()) {
        
        let finalURL = createURL(type: typeMovie) + "&page=\(page)"
        print(finalURL)
        
        AF.request(finalURL, method: .get).responseDecodable(of: Results.self) { response in
            guard let movies = response.value?.results else { return }
            guard let pages = response.value?.total_pages else { return }
            competion(movies, pages)
        }
    }
    
    func getMovieDetail(id: Int, competion: @escaping ([ProductionCompany]) -> ()) {
        let finalURL = "\(movieURL)/\(id)?\(parameters["apiKey"]!)&\(parameters["language"]!)"
        
        AF.request(finalURL, method: .get).responseDecodable(of: MovieDetail.self) { response in
            guard let studio = response.value?.production_companies else { return }
            competion(studio)
        }
    }
    
    func getGenres(competion: @escaping ([Genres]) -> ()) {
        AF.request(genreURL, method: .get).responseDecodable(of: ResultGenres.self) { response in
                guard let genres = response.value?.genres else { return }
                competion(genres)
            }
    }
     
    func getDiscoverGenre(id: String, page: Int = 1, filter: String = "popularity.desc", competion: @escaping ([Movie], Int) -> ()) {
        let finalURL = "\(discoverURL)?\(parameters["apiKey"]!)&\(parameters["language"]!)&with_genres=\(id)&page=\(page)&sort_by=\(filter)"
        print(finalURL)
        AF.request(finalURL, method: .get).responseDecodable(of: Results.self) { response in
            guard let movies = response.value?.results else { return }
            guard let pages = response.value?.total_pages else { return }
            competion(movies, pages)
        }
    }
    
    func getCasts(id: Int, competion: @escaping ([Casts], [Crews]) -> ()) {
        let finalURL = "\(movieURL)/\(id)/credits?\(parameters["apiKey"]!)&\(parameters["language"]!)"
        print(finalURL)
        AF.request(finalURL, method: .get).responseDecodable(of: ResultCasts.self) { response in
            guard let casts = response.value?.cast else { return }
            guard let crews = response.value?.crew else { return }
            competion(casts, crews)
        }
    }
    
    func searchMovie(query: String, competion: @escaping ([Movie]) -> ()) {
        let URL = "\(searchMovieURL)?query=\(query)&\(parameters["apiKey"]!)&\(parameters["language"]!)"
        print(URL)
        AF.request(URL, method: .get).responseDecodable(of: Results.self) { response in
            guard let movies = response.value?.results else { return }
            competion(movies)
        }
    }
    
    
    func createURL(type: String) -> String{
        let URL = "\(movieURL)/\(type)?\(parameters["apiKey"]!)&\(parameters["language"]!)"
        
        return URL
    }
    
}
