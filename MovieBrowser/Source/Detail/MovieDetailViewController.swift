//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var movie: Movie? {
        didSet {
            if let posterURL = movie?.posterURL {
                vm = MovieDetailsViewModel(imageURL: posterURL)
            }
        }
    }
    var vm: MovieDetailsViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie?.title ?? ""
        releaseDate.text = movie?.formattedDate(format: "m/dd/yyyy") ?? ""
        descriptionLabel.text = movie?.overview ?? ""
        
        imageView.contentMode = .scaleAspectFit
        
        vm?.$image
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (uiImage) in
                self?.imageView.image = uiImage
            }).store(in: &cancellables)
    }
    
    deinit {
        print("Deinit \(self)")
    }
}
