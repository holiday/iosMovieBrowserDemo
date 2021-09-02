//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let movieCellReuseIdentifier = "MovieTableViewCell"
    
    private let vm = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let movieCellNib = UINib(nibName: movieCellReuseIdentifier, bundle: nil)
        tableView.register(movieCellNib, forCellReuseIdentifier: movieCellReuseIdentifier)
        
        searchBar.delegate = self
        vm.setup()
        
        setupListeners()
    }
    
    func setupListeners() {
        vm.$movieResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (movies) in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.searchQuery = searchText
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let movie = self.vm.movieResults[indexPath.row]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MovieDetailViewController") as MovieDetailViewController
            vc.movie = movie
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.movieResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellReuseIdentifier, for: indexPath) as! MovieTableViewCell
        cell.accessoryType = .disclosureIndicator;
        
        let movie = vm.movieResults[indexPath.row]
        
        cell.title.text = movie.title
        cell.date.text = movie.formattedDate(format: "MMM d, yyyy")
        cell.rating.text = "\(movie.rating)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
