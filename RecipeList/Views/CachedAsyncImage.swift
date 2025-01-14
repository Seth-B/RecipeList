//
//  CachedAsyncImage.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    let _name: String
    let placeholder: () -> AnyView
    let errorImage: () -> AnyView
    
    @State private var image: UIImage? = nil
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                placeholder()
            } else {
                errorImage()
            }
        }
        .onAppear {
            Task {
                do {
                    self.image = try await ImageCache.shared.getImage(for: url, _name: _name)
                } catch {
                    print("Failed to load image: \(error)")
                }
                isLoading = false
            }
        }
    }
}
