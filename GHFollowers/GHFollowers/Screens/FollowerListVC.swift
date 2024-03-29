//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 22.01.2024.
//

import UIKit


class FollowerListVC: GFDataLoadingVC {
    
    enum Section { case main }
    
    var username: String
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        title         = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var followers: [Follower]         = []
    var filteredFollowers: [Follower] = []
    var page                          = 1
    var hasMoreFollowers              = true
    var isSearching                   = false
    var isLoadingMoreFollowers        = false
    
    var collectionView: UICollectionView!
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Follower>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Follower>
    
    private var collectionDataSource: DataSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        collectionDataSource = configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func configureSearchController() {
        let searchController                        = UISearchController()
        searchController.searchResultsUpdater       = self
        searchController.searchBar.placeholder      = "Search for a username"
        navigationItem.hidesSearchBarWhenScrolling  = false
        navigationItem.searchController             = searchController
    }
    
    
//    func getFollowers(username: String, page: Int) {
//        showLoadingView()
//        isLoadingMoreFollowers = true
//
//        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            switch result {
//            case .success(let followers):
//                self.updateUI(with: followers)
//            case .failure(let error):
//                self.presentGFAlertOnMainTread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
//            }
//            self.isLoadingMoreFollowers = false
//        }
//    }
    
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Bad Stuff Happend", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
            isLoadingMoreFollowers = false
        }
        
//        Task {
//            guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: page) else {
//                presentDefaultError()
//                dismissLoadingView()
//                return
//            }
//            updateUI(with: followers)
//            dismissLoadingView()
//        }
    }
    
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        self.followers.append(contentsOf: followers)
       
        if followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😃"
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
                return
            }
        }
        self.updateData(on: self.followers)
    }
    
    
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, follower -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell else {
                return UICollectionViewCell() }
            cell.set(follower: follower)
            return cell
        }
        return dataSource
    }
    
    
    func updateData(on followers: [Follower]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async {
            self.collectionDataSource?.apply(snapShot, animatingDifferences: true)
        }
    }
    
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                addUserToFavorites(user: user)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
        
//        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            
//            switch result {
//            case .success(let user):
//                self.addUserToFavorites(user: user)
//            case .failure(let error):
//                self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
//            }
//        }
    }
    
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { error in
            guard let error = error else {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray         = isSearching ? filteredFollowers : followers
        let follower            = activeArray[indexPath.item]
        
        let destinationVC       = UserInfoVC(userName: follower.login)
        destinationVC.delegate  = self
        let navController       = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}


extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(text.lowercased()) }
        updateData(on: filteredFollowers)
    }
}


extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
