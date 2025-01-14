//
//  FoodInfoService.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//
import Foundation

// WikipediaResponseModel
struct WikipediaSummaryResponse: Codable {
    let extract: String
    let title: String
}

class FoodInfoService {
    static let shared = FoodInfoService()
    
    // Fetch extract descriptions from wikipedia. Only available for commonly known and defined foods
    func fetchDescription(for foodName: String) async throws -> String {
        let formattedFoodName = foodName
            .lowercased() // Convert the entire string to lowercase
            .prefix(1).capitalized + foodName.dropFirst().lowercased()
            .replacingOccurrences(of: " ", with: "_")
        
        guard let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(formattedFoodName)") else {
            throw RecipeError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let response = try JSONDecoder().decode(WikipediaSummaryResponse.self, from: data)
            return response.extract

        } catch {
            print("Error decoding JSON: \(error)")
            throw RecipeError.decodingError
        }
    }
}
