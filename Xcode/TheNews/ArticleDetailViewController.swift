//
//  ArticleDetailViewController.swift
//  TheNews
//
//  Created by Assistant on 2025-06-27.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    
    private var webView: WKWebView!
    private var article: Article
    private var progressView: UIProgressView!
    private var backButton: UIButton!
    private var sourceLabel: UILabel!
    private var favoriteButton: UIButton!
    private var blurEffectView: UIVisualEffectView!
    private var gradientLayer: CAGradientLayer!
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupOverlayElements()
        loadArticle()
        
        // Hide navigation bar for immersive experience
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore navigation bar when leaving
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update gradient mask frame
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 80)
        }
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupOverlayElements() {
        // Blur effect view for top area
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        // Progress view
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        progressView.isHidden = true
        
        // Back button
        backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Source label
        sourceLabel = UILabel()
        sourceLabel.text = article.source?.name?.uppercased()
        sourceLabel.font = .boldSystemFont(ofSize: 14)
        sourceLabel.textColor = .white
        sourceLabel.textAlignment = .center
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Favorite button
        favoriteButton = UIButton(type: .system)
        favoriteButton.tintColor = .white
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        updateFavoriteButton()
        
        view.addSubview(blurEffectView)
        view.addSubview(progressView)
        view.addSubview(backButton)
        view.addSubview(sourceLabel)
        view.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            // Blur effect view - covers top area with gradient fade
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.heightAnchor.constraint(equalToConstant: 80),
            
            // Progress view
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            
            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Source label
            sourceLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            sourceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sourceLabel.heightAnchor.constraint(equalToConstant: 24),
            sourceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Favorite button
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Add gradient mask to blur effect for fade out effect
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7, 1.0]
        blurEffectView.layer.mask = gradientLayer
        
        // Add padding to source label
        sourceLabel.layoutMargins = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    }
    
    private func loadArticle() {
        guard let url = article.url else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Observe loading progress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func updateFavoriteButton() {
        let isFavorite = FavoritesManager.shared.isFavorite(article)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteButtonTapped() {
        FavoritesManager.shared.toggleFavorite(article)
        updateFavoriteButton()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            progressView.setProgress(progress, animated: true)
            
            if progress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3) {
                    self.progressView.alpha = 0
                } completion: { _ in
                    self.progressView.isHidden = true
                    self.progressView.alpha = 1
                }
            } else {
                progressView.isHidden = false
            }
        }
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}

// MARK: - WKNavigationDelegate
extension ArticleDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.setProgress(0, animated: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        
        // Show error alert
        let alert = UIAlertController(
            title: "加载失败",
            message: "无法加载文章内容，请检查网络连接。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}