//
//  RecipeModel.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//
import Foundation

struct Recipe: Codable, Identifiable {
    var id: String { uuid } // `id` for Identifiable
    let uuid: String
    let name: String
    let cuisine: String
    let photo_url_large: URL? // 700x700
    let photo_url_small: URL? // 150x150 or 200x200
    let source_url: URL?
    let youtube_url: URL?
    var description: String? // Wikipedia Sourced blurbs
}
