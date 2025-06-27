//
//  Created by Daniel on 12/13/20.
//

import UIKit

class NewsCollectionHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var items: [Article] = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = items[indexPath.row]
        guard article.url != nil else { return }
        
        let detailViewController = ArticleDetailViewController(article: article)
        
        if let viewController = collectionView.findViewController() {
            viewController.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

}
