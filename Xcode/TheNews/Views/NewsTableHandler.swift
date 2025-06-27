//
//  Created by Daniel on 12/12/20.
//

import UIKit

class NewsTableHandler: NSObject, UITableViewDataSource, UITableViewDelegate {

    var articles: [Article] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        guard article.url != nil else { return }
        
        let detailViewController = ArticleDetailViewController(article: article)
        
        if let viewController = tableView.findViewController() {
            viewController.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

}
