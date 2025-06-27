//
//  Created by Daniel on 12/12/20.
//

import UIKit
import SafariServices

class CNNHandler: NewsTableHandler {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CNNCell.identifier) as! CNNCell

        let article = articles[indexPath.row]
        cell.load(article: article, downloader: ImageDownloader.shared)
        cell.configureFavoriteButton(for: article, in: tableView, at: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = articles[indexPath.row]
        guard let url = item.url else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        
        if let viewController = tableView.findViewController() {
            viewController.present(safariViewController, animated: true)
        }
    }

}
