//
//  Follower.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 29.01.2024.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
