//
//  SearchBar.swift
//  GithubRepository
//
//  Created by Muhammad Yousuf Saif on 1/20/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    @State private var isEditing = false
    
    var onCommit: (String) -> Void

    var body: some View {
        HStack {
            TextField("Search ...", text: $text, onCommit: {
                self.isSearching = true
                self.onCommit(self.text)
            })
            .padding(7)
            .padding(.horizontal, 15)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .onTapGesture {
                self.isEditing = true
            }
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}
