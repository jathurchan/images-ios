
import UIKit

extension ImageGridViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, HitImage.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, HitImage.ID>
    
    func updateSnapshot(reloading idsThatChanged: [HitImage.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(HitImage.sampleData.map { $0.id })
        if !idsThatChanged.isEmpty {
            snapshot.reloadItems(idsThatChanged)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
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
