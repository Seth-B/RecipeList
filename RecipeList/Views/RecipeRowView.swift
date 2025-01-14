
//
//  RecipeRowView.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            if let photoURL = recipe.photo_url_small {
                CachedAsyncImage(
                    url: photoURL,
                    _name: recipe.name,
                    placeholder: { AnyView(ProgressView().frame(width: 75, height: 75)) },
                    errorImage: { AnyView(Rectangle().fill(Color.gray).frame(width: 75, height: 75)) }
                )
                .frame(width: 75, height: 75)
                .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}
