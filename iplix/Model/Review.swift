//
//  Review.swift
//  iplix
//
//  Created by Farhan Adji on 15/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct Review: Decodable {
    let movie_id: Int?
    let review: String?
    let stars_value: Double?
    let title: String?
    let user_email: String?
    let user_name: String?
    let timestamp: Double?
}
