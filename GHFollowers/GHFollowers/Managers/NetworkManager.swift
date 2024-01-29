//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 29.01.2024.
//

import Foundation

class NetworkManager {
    
    static let shared   = NetworkManager()
    let baseUrl         = "https://api.github.com/"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseUrl + "users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This username created an invalid request. Please try again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            <#code#>
        }
        
        task.resume()
    }
}
