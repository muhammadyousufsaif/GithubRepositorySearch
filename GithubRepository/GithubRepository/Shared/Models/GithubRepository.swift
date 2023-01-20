//
//  GithubRepository.swift
//  GithubRepository
//
//  Created by Muhammad Yousuf Saif on 1/20/23.
//

import Foundation
import SwiftUI

struct GithubRepository: Codable, Identifiable {
    
    let id: Int
    let name: String
    let full_name: String
    let html_url: URL
    let description: String?
}

struct GithubSearchResults: Codable {
    let items: [GithubRepository]
}
