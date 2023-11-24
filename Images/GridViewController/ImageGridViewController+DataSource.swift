
import UIKit

extension ImageGridViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Hit.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hit.ID>
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Hit.ID> { [unowned self] cell, indexPath, hitId in
            
            if let hit = self.hit(with: hitId) {
                var contentConfiguration = cell.hitImageConfiguration()
                contentConfiguration.image = hit.image
                contentConfiguration.isSelected = cell.isSelected
                
                cell.contentConfiguration = contentConfiguration
                ImageCache.shared.loadImage(url: hit.preview as NSURL, hitId: hitId) { hitId, loadedImage in
                    if let loadedImage {
                        contentConfiguration.image = loadedImage
                        contentConfiguration.isSelected = cell.isSelected
                        cell.contentConfiguration = contentConfiguration
                    }
                }
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Hit.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func hit(with id: Hit.ID) -> Hit? {
        if let index = hitsStore.hits.indexOfHit(with: id) {
            return hitsStore.hits[index]
        }
        return nil
    }
    
    func updateSnapshot(reloading idsThatChanged: [Hit.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(hitsStore.hits.map { $0.id })
        if !idsThatChanged.isEmpty {
            snapshot.reloadItems(idsThatChanged)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
