
import UIKit

extension ImageGridViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Hit.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hit.ID>
}
