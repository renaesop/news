import UIKit

class TapestryHandler: NewsTableHandler {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TapestryCell.identifier) as! TapestryCell

        let article = articles[indexPath.row]
        cell.load(article: article)
        cell.configureFavoriteButton(for: article, in: tableView, at: indexPath)

        return cell
    }

}
