//
//  RecipeViewModel.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//

import Foundation

// Encoded URL's to make it non-trivial to find public github project
enum ENDPOINT: String {
    case primary = "aHR0cHM6Ly9kM2piYjhuNXdrMHF4aS5jbG91ZGZyb250Lm5ldC9yZWNpcGVzLmpzb24="
    case emptyData = "aHR0cHM6Ly9kM2piYjhuNXdrMHF4aS5jbG91ZGZyb250Lm5ldC9yZWNpcGVzLWVtcHR5Lmpzb24="
    case invalidData = "aHR0cHM6Ly9kM2piYjhuNXdrMHF4aS5jbG91ZGZyb250Lm5ldC9yZWNpcGVzLW1hbGZvcm1lZC5qc29u"
    
    var url: String {
        let data = Data(base64Encoded: self.rawValue)!;
        return String(data: data, encoding: .utf8)!
    }
}

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func loadRecipes() async {
        
        isLoading = true
        defer { isLoading = false }
        do {
            recipes = try await RecipeService.shared.fetchRecipes(from: ENDPOINT.primary.url)
        } catch {
            errorMessage = "Failed to load recipes. Please try again."
            print("Error loading recipes: \(error)")
        }
    }
}
