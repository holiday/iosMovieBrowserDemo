//
//  Network.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit
import Combine

enum NetworkError: Error {
    case error(Error)
    case badURL
    case decodingError
}

class Network {
    static let apiKey = "ed0eb41f06afedd7d496dbe4d570d948"
    
    private static var cancellables = Set<AnyCancellable>()
    
    static func movieSearch(query: String) -> AnyPublisher<MovieResults, NetworkError> {
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(encodedQuery)&page=1&include_adult=false") else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        let urlRequest = URLRequest(url: url)
        
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: MovieResults.self, decoder: jsonDecoder)
            .mapError{ NetworkError.error($0) }
            .eraseToAnyPublisher()
    }
    
    static func fetchImage(imageURL: String) -> AnyPublisher<UIImage, Error> {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageURL)")!
        
        let urlRequest = URLRequest(url: url)
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .tryMap { (data) -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw NetworkError.decodingError
                }

                return image
            }
            .mapError{ NetworkError.error($0) }
            .eraseToAnyPublisher()
    }
}
