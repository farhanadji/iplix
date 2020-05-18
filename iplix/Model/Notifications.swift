//
//  Notifications.swift
//  iplix
//
//  Created by Farhan Adji on 30/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct Notifications: Decodable {
    let title: String?
    let description: String?
    let movies: Movie
}
