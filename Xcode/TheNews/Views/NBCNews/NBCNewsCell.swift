//
//  Created by Daniel on 12/17/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit

class NBCNewsCell: NewsCell {

    static let identifier: String = "NBCNewsCell"

    private static let imageHeight: CGFloat = 90

    override func config() {
        super.config()

        source.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
        source.textColor = .systemBlue

        title.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
        title.numberOfLines = 3

        [articleImageView, source, title, favoriteButton].forEach { item in
            contentView.addSubviewForAutoLayout(item)
        }

        let inset: CGFloat = 20
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: NBCNewsCell.imageHeight),
            articleImageView.widthAnchor.constraint(equalToConstant: NBCNewsCell.imageHeight),

            source.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            source.topAnchor.constraint(equalTo: articleImageView.topAnchor),
            source.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            title.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: source.bottomAnchor, constant: 6),
            title.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            contentView.bottomAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: inset),
            
            // Favorite button constraints
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func load(article: Article, downloader: ImageDownloader) {
        title.text = article.titleDisplay
        source.text = article.source?.name?.uppercased()
        load(urlString: article.urlToImage, downloader: downloader)
    }

}
