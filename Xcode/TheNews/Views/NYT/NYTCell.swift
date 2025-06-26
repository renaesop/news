//
//  Created by Daniel on 12/12/20.
//

import UIKit

class NYTCell: NewsCell {

    static let identifier: String = "NYTCell"

    override func config() {
        super.config()

        title.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 25)

        summary.font = UIFont(name: "Times New Roman", size: 18)
        summary.textColor = .secondaryLabel

        source.textColor = .systemGray4
        source.font = UIFont(name: "Times New Roman", size: 11)

        [title, summary, articleImageView, source, favoriteButton].forEach {
            contentView.addSubviewForAutoLayout($0)
        }

        let imageHeight: CGFloat = 200
        let inset: CGFloat = 15
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            title.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: inset),
            title.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            summary.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            summary.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: inset),
            contentView.readableContentGuide.trailingAnchor.constraint(equalTo: summary.trailingAnchor, constant: inset),

            articleImageView.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: inset),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: inset),
            contentView.readableContentGuide.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: inset),
            articleImageView.heightAnchor.constraint(equalToConstant: imageHeight),

            source.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 3),
            contentView.readableContentGuide.trailingAnchor.constraint(equalTo: source.trailingAnchor, constant: inset),

            contentView.bottomAnchor.constraint(equalTo: source.bottomAnchor, constant: 28),
            
            // Favorite button constraints
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -inset),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func load(article: Article, downloader: ImageDownloader) {
        title.text = article.titleDisplay
        summary.text = article.description
        source.text = article.source?.name
        load(urlString: article.urlToImage, downloader: downloader)
    }

}
