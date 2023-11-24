
import UIKit

extension ImageGridViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Hit.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hit.ID>
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Hit.ID> { [weak self] cell, indexPath, hitId in
            
            guard let self = self else { return }
            
            let hit = hit(with: hitId)
            
            var contentConfiguration = cell.hitImageConfiguration()
            contentConfiguration.image = hit.image
            
            ImageCache.shared.loadImage(url: hit.preview as NSURL, hitId: hitId) { [weak self] hitId, loadedImage in
                
                guard let self = self else { return }
                
                if let image = loadedImage {
                    var updatedSnapshot = self.dataSource.snapshot()
                    if let dataSourceIndex = updatedSnapshot.indexOfItem(hitId) {
                        self.hitsStore.hits[dataSourceIndex].image = image
                        updatedSnapshot.reconfigureItems([hitId])
                        self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
                    }
                }
            }
            
            cell.contentConfiguration = contentConfiguration
            
        }
        
        dataSource = DataSource(collectionView: collectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Hit.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func hit(with id: Hit.ID) -> Hit {
        let index = hitsStore.hits.indexOfHit(with: id)
        return hitsStore.hits[index]
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
