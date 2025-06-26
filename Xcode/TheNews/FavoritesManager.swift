//
//  FavoritesManager.swift
//
//  Created by Assistant on 2025-06-26.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "FavoriteArticles"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // Save favorite articles
    func saveFavorite(_ article: Article) {
        var favorites = getFavorites()
        
        // Check if article already exists
        if !favorites.contains(where: { $0.url == article.url }) {
            favorites.insert(article, at: 0) // Add to beginning
            saveFavorites(favorites)
        }
    }
    
    // Remove favorite article
    func removeFavorite(_ article: Article) {
        var favorites = getFavorites()
        favorites.removeAll { $0.url == article.url }
        saveFavorites(favorites)
    }
    
    // Check if article is favorite
    func isFavorite(_ article: Article) -> Bool {
        let favorites = getFavorites()
        return favorites.contains { $0.url == article.url }
    }
    
    // Toggle favorite status
    func toggleFavorite(_ article: Article) {
        if isFavorite(article) {
            removeFavorite(article)
        } else {
            saveFavorite(article)
        }
    }
    
    // Get all favorite articles
    func getFavorites() -> [Article] {
        guard let data = userDefaults.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([Article].self, from: data) else {
            return []
        }
        return favorites
    }
    
    // Save favorites to UserDefaults
    private func saveFavorites(_ favorites: [Article]) {
        if let data = try? JSONEncoder().encode(favorites) {
            userDefaults.set(data, forKey: favoritesKey)
        }
    }
    
    // Clear all favorites
    func clearAllFavorites() {
        userDefaults.removeObject(forKey: favoritesKey)
    }
}