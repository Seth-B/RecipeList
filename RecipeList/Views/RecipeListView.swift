//
//  RecipeListView.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var selectedRecipe: Recipe? = nil
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Recipes...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            } else if viewModel.recipes.isEmpty {
                Text("No recipes found.")
            } else {
                List(viewModel.recipes) { recipe in
                    RecipeRowView(recipe: recipe)
                        .onTapGesture {
                            selectedRecipe = recipe
                        }
                }
                .listStyle(PlainListStyle())
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Clear Disk Cache") {
                        ImageCache.shared.clearDiskCache()
                    }
                    Button("Clear Memory Cache") {
                        ImageCache.shared.clearMemoryCache()
                    }
                    Button("Clear All Cache") {
                        ImageCache.shared.clearDiskCache()
                        ImageCache.shared.clearMemoryCache()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .accessibilityLabel("Options")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline) // Compact header
        .navigationTitle("Recipes")
        .refreshable {
            await viewModel.loadRecipes()
        }
        .onAppear {
            Task {
                await viewModel.loadRecipes()
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailView(recipe: recipe)
        }
    }
}
