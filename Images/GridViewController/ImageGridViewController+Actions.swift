import UIKit

extension ImageGridViewController {
    @objc func didPressCancelButton() {
        clearSelectedItems()
        updateToolbarButtons()
    }
    
    @objc func didPressDoneButton() {
        guard let indexPaths = collectionView.indexPathsForSelectedItems,
              !indexPaths.isEmpty
        else {
            fatalError()
        }
        let hitsIds = indexPaths.compactMap { dataSource.itemIdentifier(for: $0) }
        let hits = hitsIds.compactMap { hit(with: $0) }
        let viewController = ImagesViewController(hits: hits)
        present(viewController, animated: true)
    }
}


