//
//  RecipeListApp.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//

import SwiftUI

@main
struct RecipeListApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipeListView()
                    .environmentObject(RecipeViewModel())
            }
        }
    }
}
