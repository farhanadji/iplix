//
//  Ratings.swift
//  iplix
//
//  Created by Farhan Adji on 16/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct Ratings: Decodable {
    let movie_id: Int?
    let rating_count: Int?
    let rating_average: Double?
    let one_stars: Int?
    let two_stars: Int?
    let three_stars: Int?
    let four_stars: Int?
    let five_stars: Int?
}
