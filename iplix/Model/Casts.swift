//
//  Casts.swift
//  iplix
//
//  Created by Farhan Adji on 07/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct ResultCasts: Codable {
    let cast: [Casts]
    let crew: [Crews]
}

struct Casts: Codable {
    let cast_id: Int?
    let character: String?
    let credit_id: String?
    let gender: Int?
    let id: Int?
    let name: String?
}

struct Crews: Codable {
    let credit_id: String?
    let department: String?
    let gender: Int?
    let id: Int?
    let job: String?
    let name: String?
}
