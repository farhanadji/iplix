//
//  Constants.swift
//  iplix
//
//  Created by Farhan Adji on 16/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct K {
    struct identifier {
        static let slider = "sliderCell"
        static let movie = "movieCell"
        static let rating = "ratingCell"
        static let review = "reviewCell"
        static let title = "titleCell"
        static let popular = "popularCell"
        static let sliderTable = "sliderTableCell"
        static let addreview = "addReviewCell"
        static let comment = "commentCell"
        static let movietable = "movieListCell"
        static let account = "accountCell"
        static let logout = "logoutCell"
        static let search = "searchCell"
        static let category = "categoryCell"
        static let notification = "notificationCell"
        static let profilePicture = "profilePictureCell"
        static let nameProfile = "nameProfileCell"
        static let emailProfile = "emailProfileCell"
        
        static let goDetailFromHome = "goToDetail"
        static let goAllFromHome = "goToAll"
        static let goAccount = "goToAccount"
        static let goReview = "goToAddReview"
        static let goDetailFromAll = "goToDetailFromAll"
        static let goAccountDetail = "goToDetailAccount"
        static let goDetailFromSearch = "goToDetailFromSearch"
        static let goLogin = "goToLogin"
        static let goRegister = "goToRegister"
        static let goDetailFromFavorite = "goToDetailFromFavorite"
        static let goMoreFromCategory = "goToMoreFromCategory"
        
        static let about = "segmentAbout"
        static let cast = "castSegment"
        static let information = "informationSegment"
        static let main = "Main"
        static let movie_datail = "movieDetail"
        static let signin_page = "signinPage"
        static let senderHome = "home"
        static let senderCategory = "category"
    }
    
    struct nib {
        static let slideview = "SlideCollectionViewCell"
        static let movieview = "MovieCollectionViewCell"
        static let popularview = "PopularViewCell"
        static let sliderview = "SlideViewCell"
        static let ratingview = "RatingTableViewCell"
        static let addreviewview = "AddReviewTableViewCell"
        static let commentview = "CommentTableViewCell"
        static let movietableview = "MovieTableViewCell"
        static let searchtableview = "SearchTableViewCell"
        static let categorytableview = "CategoryTableViewCell"
    }
    
    struct typeMovie {
        static let popular = "popular"
        static let now_playing = "now_playing"
        static let top_rated = "top_rated"
        static let upcoming = "upcoming"
        static let similar = "/similar"
        static let recommendation = "/recommendations"
    }
    
    struct size {
        static let sliderWidth = 370
        static let sliderHeight = 180
        static let movieCollectionHeight = 300
        static let titleSize = 15.0
    }
    
    struct text {
        static let review = "Review"
        static let accountLogin = "Login/Register"
        static let ok = "Ok"
        static let errorTitle = "Error!"
        static let successReviewMsg = "Success to Add Review!"
        static let back = "Back"
        static let popular = "Popular"
        static let upcoming = "Upcoming"
        static let top_rated = "Top Rated"
        static let popular_movies = "Popular Movies"
        static let now_playing = "Now Playing"
        static let add_favorite = "Added to favorites!"
        static let confirmation = "Confirmation"
        static let remove_message1 = "Are you sure want to remove"
        static let remove_message2 = "from favorites list ?"
        static let no = "No"
        static let yes = "Yes"
        static let similar = "Similar with"
        static let recommendation = "Recomendations for you"
        static let signOut = "Do you want to sign out?"
        static let signInFailed = "Sign In Failed!"
        static let signUpFailed = "Sign Up Failed!"
        static let signUpSuccess = "Sign Up Successfully!"
        static let signUpMessage = "You have successfully registered and will be directed to home page"
    }
    
    struct collection {
        static let reviews = "reviews"
        static let favorites = "favorites"
        static let ratings = "ratings"
        static let profile = "profile"
    }
    
    struct reviews_attr {
        static let email = "user_email"
        static let name = "user_name"
        static let movie = "movie_id"
        static let stars = "stars_value"
        static let title = "title"
        static let review = "review"
        static let time = "timestamp"
    }
    
    struct ratings_attr {
        static let movie = "movie_id"
        static let count = "rating_count"
        static let average = "rating_average"
        static let onestars = "one_stars"
        static let twostars = "two_stars"
        static let threestars = "three_stars"
        static let fourstars = "four_stars"
        static let five_stars = "five_stars"
    }
    
    struct favorites_attr {
        static let movie_id = "movie.id"
        static let user = "user"
        static let movie = "movie"
        static let id = "id"
        static let popularity = "popularity"
        static let vote = "vote_count"
        static let poster = "poster_path"
        static let backdrop = "backdrop_path"
        static let title = "title"
        static let genre = "genre_ids"
        static let overview = "overview"
        static let release = "release_date"
        static let vote_average = "vote_average"
    }
    
    struct URL {
        static let default_backdrop = "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/9/2/8/5/235829-6-eng-GB/Feed-Test-SIC-Feed-20142_news_large.jpg"
        static let storage = "gs://iplix-27328.appspot.com"
    }
}
