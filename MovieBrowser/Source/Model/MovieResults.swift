//
//  MovieResults.swift
//  MovieBrowser
//
//  Created by Rashaad Ramdeen on 9/2/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    var page: Int
    var results: [Movie]
    var totalPages: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
