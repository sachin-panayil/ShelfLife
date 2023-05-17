//
//  Recipe.swift
//  ShelfLife
//
//  Created by Sachin Panayil on 5/1/23.
//

import Foundation

struct Recipe: Codable {
    let id: Int?
    let title: String?
    let image: String?
    let imageType: String?
    let usedIngredientCount, missedIngredientCount: Int?
    let missedIngredients, usedIngredients: [SedIngredient]?
    let unusedIngredients: [SedIngredient]?
    let likes: Int?
}

struct SedIngredient: Codable {
    let id: Int?
    let amount: Double?
    let unit, unitLong, unitShort, aisle: String?
    let name, original, originalName: String?
    let meta: [String]?
    let image: String?
    let extendedName: String?
}
