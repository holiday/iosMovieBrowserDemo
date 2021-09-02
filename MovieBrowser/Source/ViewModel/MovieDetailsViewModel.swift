//
//  MovieDetailsViewModel.swift
//  MovieBrowser
//
//  Created by Rashaad Ramdeen on 9/2/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import Combine
import UIKit

class MovieDetailsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var imageURL: String
    @Published var image: UIImage?
    
    init(imageURL: String) {
        self.imageURL = imageURL
        
        $imageURL
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] (imageURLString) in
                guard let self = self else { return }
                
                //Fetch image
                Network.fetchImage(imageURL: imageURLString)
                    .sink { (completion) in
                        if case let .failure(networkError) = completion {
                            print(networkError.localizedDescription)
                        }
                    } receiveValue: { (uiImage) in
                        self.image = uiImage
                    }.store(in: &self.cancellables)

            }.store(in: &cancellables)
    }
}
