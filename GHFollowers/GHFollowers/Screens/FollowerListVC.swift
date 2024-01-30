//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 22.01.2024.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
            guard let followers = followers else {
                self.presentGFAlertOnMainTread(title: "Bad Stuff Happend", message: errorMessage ?? "", buttonTitle: "Ok")
               return
            }
            
            followers.forEach {
                print($0.login)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
