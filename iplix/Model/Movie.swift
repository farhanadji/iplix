//
//  Movies.swift
//  iplix
//
//  Created by Farhan Adji on 02/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let popularity: Double?
    let vote_count: Int?
    let poster_path: String?
    let id: Int?
    let backdrop_path: String?
    let title: String?
    let genre_ids: [Int]?
    let overview: String?
    let release_date: String?
    let vote_average: Double?
}
