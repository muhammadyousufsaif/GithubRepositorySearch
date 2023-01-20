//
//  GithubRepoRowView.swift
//  GithubRepository
//
//  Created by Muhammad Yousuf Saif on 1/20/23.
//

import SwiftUI

struct GithubRepoRowView: View {
    
    var model: GithubRepository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.name)
            Text(model.description ?? model.full_name)
            Text(model.html_url.absoluteString)
        }
    }
}

