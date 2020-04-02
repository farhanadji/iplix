//
//  Genres.swift
//  iplix
//
//  Created by Farhan Adji on 02/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct ResultGenres: Codable {
    let genres: [Genres]
}

struct Genres: Codable {
    let id: Int
    let name: String
}
