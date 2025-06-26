//
//  Created by Daniel on 12/18/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit

class ApolloHandler: NewsTableHandler {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApolloCell.identifier) as! ApolloCell

        let article = articles[indexPath.row]
        cell.load(article: article)
        
        // Configure favorite button
        cell.updateFavoriteButton(isFavorite: FavoritesManager.shared.isFavorite(article))
        cell.favoriteAction = { [weak self] in
            FavoritesManager.shared.toggleFavorite(article)
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        return cell
    }

}
