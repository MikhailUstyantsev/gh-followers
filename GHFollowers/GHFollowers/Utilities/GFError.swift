//
//  GFError.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 03.02.2024.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername    = "This username created an invalid request. Please try again"
    case unableToComplete   = "Unable to connect your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again"
    case invalidData        = "Data received from the server was invalid. Please try again"
    case unableToFavorite   = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
}
