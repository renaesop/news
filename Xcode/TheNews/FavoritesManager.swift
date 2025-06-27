//
//  FavoritesManager.swift
//
//  Created by Assistant on 2025-06-26.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "FavoriteArticles"
    private let dislikesKey = "DislikedArticles"
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
        
        // Remove from dislikes if it was disliked
        if isDisliked(article) {
            removeDislike(article)
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
    
    // MARK: - Dislike functionality
    
    // Save disliked article
    func saveDislike(_ article: Article) {
        var dislikes = getDislikes()
        
        // Check if article already exists
        if !dislikes.contains(where: { $0.url == article.url }) {
            dislikes.insert(article, at: 0) // Add to beginning
            saveDislikes(dislikes)
        }
        
        // Remove from favorites if it was favorited
        if isFavorite(article) {
            removeFavorite(article)
        }
    }
    
    // Remove disliked article
    func removeDislike(_ article: Article) {
        var dislikes = getDislikes()
        dislikes.removeAll { $0.url == article.url }
        saveDislikes(dislikes)
    }
    
    // Check if article is disliked
    func isDisliked(_ article: Article) -> Bool {
        let dislikes = getDislikes()
        return dislikes.contains { $0.url == article.url }
    }
    
    // Toggle dislike status
    func toggleDislike(_ article: Article) {
        if isDisliked(article) {
            removeDislike(article)
        } else {
            saveDislike(article)
        }
    }
    
    // Get all disliked articles
    func getDislikes() -> [Article] {
        guard let data = userDefaults.data(forKey: dislikesKey),
              let dislikes = try? JSONDecoder().decode([Article].self, from: data) else {
            return []
        }
        return dislikes
    }
    
    // Save dislikes to UserDefaults
    private func saveDislikes(_ dislikes: [Article]) {
        if let data = try? JSONEncoder().encode(dislikes) {
            userDefaults.set(data, forKey: dislikesKey)
        }
    }
    
    // Clear all dislikes
    func clearAllDislikes() {
        userDefaults.removeObject(forKey: dislikesKey)
    }
}