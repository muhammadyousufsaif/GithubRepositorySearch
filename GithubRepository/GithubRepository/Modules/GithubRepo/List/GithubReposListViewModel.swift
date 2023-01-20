//
//  GithubReposListViewModel.swift
//  GithubRepository
//
//  Created by Muhammad Yousuf Saif on 1/20/23.
//

import Foundation
import Combine
import SwiftUI

class GithubReposListViewModel: ObservableObject {
    
    @Published var repositories = [GithubRepository]()
    @Published var error: Error?
    private var repositoryModel: RepositoryModel
    private var cancellable: AnyCancellable?
    @State var hasMorePages = false
    private var perPage = 30
    var page = 1
  
    init(repositoryModel: RepositoryModel = RepositoryModel()) {
        self.repositoryModel = repositoryModel
        self.repositories = repositoryModel.repositories
    }
    
    func fetchRepositories(searchText: String) {
        cancellable = repositoryModel.searchPublisher(query: searchText, page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print("Publisher completed with status: \(completion)")
                if case let .failure(error) = completion {
                    DispatchQueue.main.async {
                        self.error = error
                        self.hasMorePages = false
                    }
                }
            }, receiveValue: { searchResults in
                print("Received search results: \(searchResults)")
                DispatchQueue.main.async {
                    if searchResults.count == self.perPage {
                        self.page += 1
                        self.hasMorePages = true
                    } else {
                        self.hasMorePages = false
                    }
                    if self.page == 1 {
                        self.repositories = searchResults
                    } else {
                        self.repositories.append(contentsOf: searchResults)
                    }
                }
            })
    }
    
}
