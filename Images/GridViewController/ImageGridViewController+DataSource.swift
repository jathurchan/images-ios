
import UIKit

extension ImageGridViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, HitImage.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, HitImage.ID>
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(HitImage.sampleData.map { $0.id })
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(
        cell: UICollectionViewListCell, indexPath: IndexPath, id: HitImage.ID
    ) {
        let hitImage = HitImage.sampleData[indexPath.item]
        var contentConfiguration = cell.hitImageConfiguration()
        contentConfiguration.image = hitImage.image
        cell.contentConfiguration = contentConfiguration
    }
    
    func hitImage(withId id: HitImage.ID) -> HitImage {
        let index = hitImages.indexOfHitImage(withId: id)
        return hitImages[index]
    }
    
}
