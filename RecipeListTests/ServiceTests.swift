
//
//  ServiceTests.swift
//  RecipeList
//
//  Created by Seth Burger on 1/14/25.
//

import XCTest
@testable import RecipeList

final class RecipeServiceTests: XCTestCase {
    var service: RecipeService!
    var session: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        session = URLSessionMock()
        service = RecipeService(session: session)
    }
    
    override func tearDown() {
        service = nil
        session = nil
        super.tearDown()
    }
    
    func testSuccessfulFetch() async throws {
        // Mock valid JSON response
        let json = """
        {
           "recipes" : [
                {
                    "id": "1",
                    "uuid": "abc123",
                    "name": "Pasta",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/pasta.jpg",
                    "photo_url_small": "https://example.com/pasta-small.jpg",
                }
            ]
        }
        """
        session.data = json.data(using: .utf8)
        
        let recipes = try await service.fetchRecipes(from: "https://example.com/recipes.json")
        
        XCTAssertEqual(recipes.count, 1, "Should fetch one recipe.")
        XCTAssertEqual(recipes.first?.name, "Pasta", "Recipe name should match.")
    }
    
    func testMalformedData() async {
        // Mock malformed JSON response
        let json = "{ invalid json }"
        session.data = json.data(using: .utf8)
        
        do {
            _ = try await service.fetchRecipes(from: "https://example.com/recipes.json")
            XCTFail("Expected an error but did not get one.")
        } catch {
            XCTAssertEqual(error as? RecipeError, .decodingError, "Should throw a decoding error.")
        }
    }
    
    func testEmptyData() async throws {
        // Mock empty JSON response
        
        let json = """
        {
            "recipes": []
        }
        """
        session.data = json.data(using: .utf8)
        
        let recipes = try await service.fetchRecipes(from: "https://example.com/recipes.json")
        
        XCTAssertTrue(recipes.isEmpty, "Should return an empty array for empty data.")
    }
}
