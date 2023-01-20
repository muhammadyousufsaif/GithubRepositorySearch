//
//  RepositoryModel.swift
//  GithubRepository
//
//  Created by Muhammad Yousuf Saif on 1/20/23.
//

import SwiftUI
import Combine

class RepositoryModel: ObservableObject {
    @Published var repositories = [GithubRepository]()
    @Published var error: Error?
    private var cancellable: AnyCancellable?
    
    func fetchRepositories(query: String, page: Int) {
        cancellable = searchPublisher(query: query, page: page)
            .sink(receiveCompletion: { completion in
                print("Publisher completed with status: \(completion)")
                if case let .failure(error) = completion {
                    self.error = error
                }
            }, receiveValue: { searchResults in
                print("Received search results: \(searchResults)")
                if page == 1 {
                    self.repositories = searchResults
                } else {
                    self.repositories.append(contentsOf: searchResults)
                }
            })
    }
    
    func searchPublisher(query: String, page: Int) -> AnyPublisher<[GithubRepository], Error> {
        let url = URL(string: "https://api.github.com/search/repositories")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "page", value: String(page)),
                ]
        var request = URLRequest(url: components.url!)
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map {
                print("Search results: \($0.data)")
                return $0.data
            }
            .decode(type: GithubSearchResults.self, decoder: JSONDecoder())
            .map {
                print("Search results: \($0.items)")
                return $0.items
            }
            .eraseToAnyPublisher()
    }
}

enum APIError: Error {
    case invalidResponse(HTTPURLResponse)
    case decodingError(DecodingError)
    case unknown(Error)
    
    var errorMessageString: String {
        switch self {
        case .invalidResponse:
            return "Invalid URL encountered. Can't proceed with the request"
        case .decodingError:
            return "Encountered an error while decoding incoming server response. The data couldn’t be read because it isn’t in the correct format."
        case .unknown(let error):
            return "Invalid response code encountered from the server. Expected 200, received \(error.localizedDescription)"
        }
    }
}
