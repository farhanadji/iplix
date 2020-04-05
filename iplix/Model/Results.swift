//
//  Results.swift
//  iplix
//
//  Created by Farhan Adji on 02/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let page: Int
    let results: [Movie]
}
