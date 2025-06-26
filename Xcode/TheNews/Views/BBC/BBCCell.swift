//
//  Created by Daniel on 12/12/20.
//

import UIKit

class BBCCell: NewsCell {

    static let identifier: String = "BBCCell"

    private static let imageWidth: CGFloat = 140
    private static let imageHeight: CGFloat = 85

    private var main = UIView()

    override func config() {
        super.config()

        title.font = UIFont(name: "Baskerville-SemiBold", size: 18)
        
        ago.textColor = .secondaryLabel
        ago.font = .preferredFont(forTextStyle: .caption1)

        main = UIView()
        contentView.addSubviewForAutoLayout(main)

        let inset: CGFloat = 10
        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset * 2),
            main.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset * 2),
            main.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            main.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])

        [articleImageView, title, ago, favoriteButton].forEach {
            main.addSubviewForAutoLayout($0)
        }

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: main.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: main.leadingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: BBCCell.imageHeight),
            articleImageView.widthAnchor.constraint(equalToConstant: BBCCell.imageWidth),

            title.topAnchor.constraint(equalTo: articleImageView.topAnchor, constant: -4),
            title.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: inset),
            title.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -inset),

            ago.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: inset),
            ago.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -inset),
            ago.topAnchor.constraint(equalTo: title.bottomAnchor, constant: inset),

            main.bottomAnchor.constraint(equalTo: ago.bottomAnchor),
            
            // Favorite button constraints
            favoriteButton.centerYAnchor.constraint(equalTo: main.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: main.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func load(article: Article,
              row: Int,
              downloader: ImageDownloader = ImageDownloader.shared) {
        title.text = article.titleDisplay
        ago.text = article.agoSource

        let size = CGSize(width: BBCCell.imageWidth, height: BBCCell.imageHeight)
        load(urlString: article.urlToImage, downloader: downloader, size: size)
    }

}

private extension Article {

    var agoSource: String {
        var bottom = ago ?? ""
        if let source = source?.name {
            bottom += " | " + source
        }
        return bottom
    }

}
