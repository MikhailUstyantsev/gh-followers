//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 11.02.2024.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var userName: String
    
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                print(user.bio ?? "Unknown")
            case .failure(let error):
                self.presentGFAlertOnMainTread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
