//
//  Created by Daniel on 12/12/20.
//

import UIKit

class WSJCell: NewsCell {

    static let identifier: String = "WSJCell"

    override func config() {
        super.config()

        title.font = UIFont(name: "Palatino-Bold", size: 32)

        summary.font = UIFont(name: "Palatino-Roman", size: 17)
        summary.textColor = .systemGray

        source.font = UIFont(name: "AvenirNextCondensed-Medium", size: 13)
        source.textColor = .systemGray

        ago.font = source.font
        ago.textColor = .systemGray

        [source, articleImageView, title, summary, ago, favoriteButton].forEach { item in
            contentView.addSubviewForAutoLayout(item)
        }

        let imageHeight: CGFloat = 250
        let inset: CGFloat = 15
        NSLayoutConstraint.activate([
            source.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            source.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            source.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            articleImageView.topAnchor.constraint(equalTo: source.bottomAnchor, constant: inset),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: imageHeight),

            title.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: inset),
            title.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            summary.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            summary.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            summary.trailingAnchor.constraint(equalTo: title.trailingAnchor),

            ago.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 20),
            ago.leadingAnchor.constraint(equalTo: title.leadingAnchor),

            contentView.bottomAnchor.constraint(equalTo: ago.bottomAnchor, constant: 30),
            
            // Favorite button constraints
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])

    }

    func load(article: Article, downloader: ImageDownloader) {
        title.text = article.titleDisplay
        summary.text = article.description
        source.text = article.source?.name?.uppercased()
        ago.text = article.ago?.uppercased()
        load(urlString: article.urlToImage, downloader: downloader)
    }

}
