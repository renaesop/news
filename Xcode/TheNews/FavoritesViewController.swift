//
//  FavoritesViewController.swift
//
//  Created by Assistant on 2025-06-26.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private var favorites: [Article] = []
    private let imageDownloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "收藏"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        loadFavorites()
        
        // Add navigation bar button to clear all favorites
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "清空",
            style: .plain,
            target: self,
            action: #selector(clearAllFavorites)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "FavoriteCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFavorites() {
        favorites = FavoritesManager.shared.getFavorites()
        tableView.reloadData()
        
        // Show empty state if no favorites
        if favorites.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    private func showEmptyState() {
        let emptyLabel = UILabel()
        emptyLabel.text = "暂无收藏的新闻"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .systemFont(ofSize: 18)
        tableView.backgroundView = emptyLabel
    }
    
    private func hideEmptyState() {
        tableView.backgroundView = nil
    }
    
    @objc private func clearAllFavorites() {
        let alert = UIAlertController(
            title: "清空收藏",
            message: "确定要清空所有收藏的新闻吗？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "清空", style: .destructive) { _ in
            FavoritesManager.shared.clearAllFavorites()
            self.loadFavorites()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! NewsCell
        let article = favorites[indexPath.row]
        
        // Configure cell with CNN-style layout
        setupCNNStyleCell(cell: cell, article: article)
        
        // Configure favorite button
        cell.configureFavoriteButton(for: article, in: tableView, at: indexPath)
        
        return cell
    }
    
    private func setupCNNStyleCell(cell: NewsCell, article: Article) {
        // Clear existing constraints and subviews
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Configure fonts and colors to match CNN style
        cell.summary.font = .boldSystemFont(ofSize: 20)
        cell.source.textColor = .white
        cell.source.font = UIFont.boldSystemFont(ofSize: 12)
        cell.ago.textColor = .secondaryLabel
        cell.ago.font = .preferredFont(forTextStyle: .caption1)
        
        // Set content
        cell.summary.text = article.titleDisplay
        cell.source.text = article.source?.name?.uppercased()
        cell.ago.text = article.ago?.uppercased()
        
        // Load image
        if let urlString = article.urlToImage {
            cell.load(urlString: urlString, downloader: imageDownloader)
        }
        
        // Add subviews
        [cell.articleImageView, cell.summary, cell.ago, cell.favoriteButton].forEach { item in
            cell.contentView.addSubviewForAutoLayout(item)
        }
        
        // CNN-style layout constraints
        let imageHeight: CGFloat = 210
        let inset: CGFloat = 15
        
        NSLayoutConstraint.activate([
            cell.articleImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: inset),
            cell.articleImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            cell.contentView.trailingAnchor.constraint(equalTo: cell.articleImageView.trailingAnchor),
            cell.articleImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            cell.summary.topAnchor.constraint(equalTo: cell.articleImageView.bottomAnchor, constant: inset),
            cell.summary.leadingAnchor.constraint(equalTo: cell.contentView.readableContentGuide.leadingAnchor),
            cell.summary.trailingAnchor.constraint(equalTo: cell.favoriteButton.leadingAnchor, constant: -8),
            
            cell.ago.topAnchor.constraint(equalTo: cell.summary.bottomAnchor, constant: inset),
            cell.ago.leadingAnchor.constraint(equalTo: cell.contentView.readableContentGuide.leadingAnchor),
            
            cell.contentView.bottomAnchor.constraint(equalTo: cell.ago.bottomAnchor, constant: inset),
            
            // Favorite button constraints
            cell.favoriteButton.topAnchor.constraint(equalTo: cell.summary.topAnchor),
            cell.favoriteButton.trailingAnchor.constraint(equalTo: cell.contentView.readableContentGuide.trailingAnchor),
            cell.favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            cell.favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = favorites[indexPath.row]
        if let url = article.url {
            UIApplication.shared.open(url)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = favorites[indexPath.row]
            FavoritesManager.shared.removeFavorite(article)
            loadFavorites()
        }
    }
}