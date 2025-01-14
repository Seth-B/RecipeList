//
//  RecipeService.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//

import Foundation

enum RecipeError: Error {
    case invalidURL
    case decodingError
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

class RecipeService {
    static let shared = RecipeService()
    
    // Split out for testing
    private var urlSession: URLSessionProtocol;
    
    init(session: URLSessionProtocol? = nil) {
        if let session = session {
            self.urlSession = session
        } else {
            self.urlSession = URLSession.shared
        }
    }
    
    func fetchRecipes(from url: String) async throws -> [Recipe] {
        guard let url = URL(string: url) else { throw RecipeError.invalidURL }
        
        let (data, _) = try await urlSession.data(from: url)
        
        do {
            // Decode the full list
            let response = try JSONDecoder().decode(RecipeResponse.self, from: data)

            // Filter out invalid entries
            let filteredSet = response.recipes.filter { isValidRecipe($0) }
            
            return filteredSet;
        } catch {
            // Handle JSON decoding errors
            throw RecipeError.decodingError
        }
    }
    
    private func isValidRecipe(_ recipe: Recipe) -> Bool {
        // Ensure all required fields are non-empty and valid
        return !recipe.name.isEmpty &&
               !recipe.cuisine.isEmpty &&
               !recipe.uuid.isEmpty
    }
}
