//
//  Created by Daniel on 12/17/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit

class NBCNewsCellLarge: NewsCell {

    static let identifier: String = "NBCNewsCellLarge"

    private static let imageHeight: CGFloat = 400

    override func config() {
        super.config()

        title.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 25)
        title.numberOfLines = 0
        
        source.textColor = .systemBlue

        summary.font = UIFont(name: "Times New Roman", size: 17)
        
        source.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)

        [articleImageView, title, summary, source, favoriteButton].forEach {
            contentView.addSubviewForAutoLayout($0)
        }

        let inset: CGFloat = 22
        NSLayoutConstraint.activate([
            source.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            source.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            source.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            title.topAnchor.constraint(equalTo: source.bottomAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            title.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            summary.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            summary.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            contentView.trailingAnchor.constraint(equalTo: summary.trailingAnchor, constant: inset),

            articleImageView.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 10),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            contentView.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: inset),
            articleImageView.heightAnchor.constraint(equalToConstant: 170),
            
            contentView.bottomAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: inset),
            
            // Favorite button constraints
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])

    }

    func load(article: Article) {
        title.text = article.titleDisplay
        source.text = article.source?.name?.uppercased()
        summary.text = article.descriptionOrContent
        articleImageView.load(urlString: article.urlToImage, downloader: ImageDownloader.shared)
    }

}
