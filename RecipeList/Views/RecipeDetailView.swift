//
//  RecipeDetailView.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//
import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.dismiss) var dismiss
    @State private var description: String? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let photoURL = recipe.photo_url_large {
                        CachedAsyncImage(
                             url: photoURL,
                             _name: recipe.name,
                             placeholder: { AnyView(ProgressView().frame(maxWidth: .infinity, maxHeight: 300)) },
                             errorImage: { AnyView(Rectangle().fill(Color.gray).frame(maxWidth: .infinity, maxHeight: 300)) }
                         )
                         .aspectRatio(contentMode: .fit)
                         .cornerRadius(15)
                         .shadow(radius: 5)
                    }
                    
                    if let description = description {
                        Text(description)
                            .font(.body)
                            .padding()
                    }
                    
                    HStack {
                        if let sourceURL = recipe.source_url {
                            Link(destination: sourceURL) {
                                Label("View Full Recipe", systemImage: "arrow.up.right.square")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if let youtubeURL = recipe.youtube_url {
                            Link(destination: youtubeURL) {
                                Label("YouTube", systemImage: "play.rectangle")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.horizontal)

                }
                .padding()
            }
            .navigationTitle(recipe.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                fetchDescription()
            }
        }
    }
    
    private func fetchDescription() {
        Task {
            do {
                let fetchedDescription = try await FoodInfoService.shared.fetchDescription(for: recipe.name)
                description = fetchedDescription
            } catch {
                errorMessage = "Failed to load description."
            }
            isLoading = false
        }
    }
}
