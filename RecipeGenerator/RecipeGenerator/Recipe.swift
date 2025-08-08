//
//  Recipe.swift
//  RecipeGenerator
//
//  Created by Hye Ri Kim on 8/8/25.
//

import Foundation
import FoundationModels

@Generable(description: "A simple cooking recipe")
struct Recipe {
    let title: String
    @Guide(description: "List of required ingredients")
    let ingredients: [String]
    @Guide(description: "Summary of cooking instructions")
    let steps: String
}
