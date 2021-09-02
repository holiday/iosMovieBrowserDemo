//
//  MovieDTO.swift
//  MovieBrowser
//
//  Created by Rashaad Ramdeen on 9/2/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    var title: String
    var releaseDate: Date
    var rating: Decimal
    var overview: String
    var posterURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterURL = "poster_path"
        case overview
    }
    
    func formattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: releaseDate)
    }
}
