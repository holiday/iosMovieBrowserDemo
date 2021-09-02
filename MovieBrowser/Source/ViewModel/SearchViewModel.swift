//
//  SearchViewModel.swift
//  MovieBrowser
//
//  Created by Rashaad Ramdeen on 9/2/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchQuery: String = ""
    @Published var movieResults = [Movie]()
    
    init() {
    }
    
    func setup() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] (searchStr) in
                guard let self = self else { return }
                Network.movieSearch(query: searchStr)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            //should handle error here
                            print(error.localizedDescription)
                        }
                    } receiveValue: { movieResults in
                        self.movieResults = movieResults.results
                    }.store(in: &self.cancellables)
            }.store(in: &cancellables)
    }
}
