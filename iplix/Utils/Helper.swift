//
//  Helper.swift
//  iplix
//
//  Created by Farhan Adji on 16/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct Helper {
    static func parseDataReview(data: [String: Any]) -> Review {
        let movie_id = data["movie_id"] as? Int
        let user_email = data["user_email"] as? String
        let user_name = data["user_name"] as? String
        let stars_value = data["stars_value"] as? Double
        let review = data["review"] as? String
        let title = data["title"] as? String
        let timestamp = data["timestamp"] as? Double
        
        let data = Review(movie_id: movie_id, review: review, stars_value: stars_value, title: title, user_email: user_email, user_name: user_name, timestamp: timestamp)
        return data
    }
    
    static func parseDataMovie(movieData: [String: Any]) -> Movie {
        let backdrop_path = movieData["backdrop_path"] as? String
        let genre_ids = movieData["genre_ids"] as? [Int]
        let id = movieData["id"] as? Int
        let overview = movieData["overview"] as? String
        let popularity = movieData["popularity"] as? Double
        let poster_path = movieData["poster_path"] as? String
        let release_date = movieData["release_date"] as? String
        let title = movieData["title"] as? String
        let vote_average = movieData["vote_average"] as? Double
        let vote_count = movieData["vote_count"] as? Int
        
        
        let movie = Movie(popularity: popularity, vote_count: vote_count, poster_path: poster_path, id: id, backdrop_path: backdrop_path, title: title, genre_ids: genre_ids, overview: overview, release_date: release_date, vote_average: vote_average)
        
        return movie
    }
    
    static func parseDataRating(ratingData: [String: Any]) -> Ratings {
        let movie_id = ratingData["movie_id"] as? Int
        let rating_count = ratingData["rating_count"] as? Int
        let rating_average = ratingData["rating_average"] as? Double
        let one_stars = ratingData["one_stars"] as? Int
        let two_stars = ratingData["two_stars"] as? Int
        let three_stars = ratingData["three_stars"] as? Int
        let four_stars = ratingData["four_stars"] as? Int
        let five_stars = ratingData["five_stars"] as? Int
        
        let rating = Ratings(movie_id: movie_id, rating_count: rating_count, rating_average: rating_average, one_stars: one_stars, two_stars: two_stars, three_stars: three_stars, four_stars: four_stars, five_stars: five_stars)
        
        return rating
    }
    
    static func humanizeDate(date: String) -> String {
        if !date.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateConverted = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "d MMMM yyyy"
            return dateFormatter.string(from: dateConverted!)
        } else {
            return ""
        }
    }
}
