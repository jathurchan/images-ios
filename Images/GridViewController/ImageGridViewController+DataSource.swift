
import UIKit

extension ImageGridViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, HitImage.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, HitImage.ID>
    
    func cellRegistrationHandler(
        cell: UICollectionViewCell, indexPath: IndexPath, id: HitImage.ID
    ) {
        fatalError("not implemented")
        
    }
}
