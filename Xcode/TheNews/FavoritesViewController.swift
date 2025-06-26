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
        tableView.estimatedRowHeight = 100
        
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
        
        // Configure cell
        cell.title.text = article.titleDisplay
        cell.summary.text = article.descriptionOrContent
        cell.source.text = article.source?.name
        cell.ago.text = article.ago
        
        // Configure favorite button
        cell.updateFavoriteButton(isFavorite: true)
        cell.favoriteAction = { [weak self] in
            FavoritesManager.shared.toggleFavorite(article)
            self?.loadFavorites()
        }
        
        // Load image if available
        if let urlString = article.urlToImage {
            cell.load(urlString: urlString, downloader: imageDownloader)
        }
        
        // Simple layout
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let stackView = UIStackView(arrangedSubviews: [cell.title, cell.summary, cell.source])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(stackView)
        cell.contentView.addSubview(cell.favoriteButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12),
            stackView.trailingAnchor.constraint(equalTo: cell.favoriteButton.leadingAnchor, constant: -16),
            
            cell.favoriteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.favoriteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            cell.favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            cell.favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return cell
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