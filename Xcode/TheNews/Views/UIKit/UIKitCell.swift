//
//  Created by Daniel on 12/12/20.
//

import UIKit

class UIKitCell: UITableViewCell {

    static let identifier = "UIKitCell"
    
    var favoriteButton = UIButton(type: .system)
    var favoriteAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        build()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func build() {
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .secondaryLabel
        
        // Configure favorite button
        favoriteButton.tintColor = .systemRed
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        contentView.addSubviewForAutoLayout(favoriteButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func favoriteButtonTapped() {
        favoriteAction?()
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func load(article: Article) {
        textLabel?.text = article.title
        detailTextLabel?.text = article.description
    }
    
    func configureFavoriteButton(for article: Article, in tableView: UITableView, at indexPath: IndexPath) {
        self.updateFavoriteButton(isFavorite: FavoritesManager.shared.isFavorite(article))
        self.favoriteAction = { [weak tableView] in
            FavoritesManager.shared.toggleFavorite(article)
            tableView?.reloadRows(at: [indexPath], with: .none)
        }
    }

}
