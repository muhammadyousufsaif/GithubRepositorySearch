//
//  ContentView.swift
//  GithubRepository
//
//  Created by Muhammad Yousuf Saif on 1/20/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = GithubReposListViewModel()
    @State private var query = ""
    @State private var isSearching = false
    @State private var showError = false
    @State private var showNoResultsText = false
    @State private var isLoadingMore = false
  
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $query, isSearching: $isSearching) {
                    self.viewModel.page = 1
                    self.viewModel.repositories.removeAll()
                    self.viewModel.fetchRepositories(searchText: $0)
                }
                if !viewModel.repositories.isEmpty {
                    List {
                        ForEach(viewModel.repositories) { result in
                            GithubRepoRowView(model: result)
                        }
                        if viewModel.repositories.count != 0 && !isSearching {
                            Button("Load More") {
                                self.viewModel.fetchRepositories(searchText: self.query)
                            }
                        }
                    }.onReceive(viewModel.$repositories) { results in
                        print("Results: \(results)")
                        showNoResultsText = results.isEmpty
                        if !isLoadingMore && viewModel.hasMorePages {
                            Button(action: {
                                self.isLoadingMore = true
                                self.viewModel.fetchRepositories(searchText: self.query)
                            }) {
                                Text("Load More")
                            }
                            .padding(.top)
                            .padding(.bottom)
                        }
                    }
                    .onAppear {
                        if !self.query.isEmpty {
                            self.viewModel.fetchRepositories(searchText: self.query)
                        }
                    }
                } else if isSearching {
                    Text("Loading...")
                } else if !isSearching && showNoResultsText {
                    Text("No results found")
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? ""), dismissButton: .default(Text("OK")))
            }
        }
        .onReceive(viewModel.$error) { error in
            if error != nil {
                self.showError = true
            }
        }
    }
}
