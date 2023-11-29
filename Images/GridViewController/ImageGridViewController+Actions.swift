import UIKit

extension ImageGridViewController {
    
    /// Removes all the selected images
    @objc func didPressCancelButton() {
        clearSelectedItems()
        updateToolbarButtons()
    }
    
    /// Presents a new view controller to display
    /// the selected images in a slideshow
    @objc func didPressDoneButton() {
        if let indexPaths = collectionView.indexPathsForSelectedItems,
           !indexPaths.isEmpty {
            let hitsIds = indexPaths.compactMap { dataSource.itemIdentifier(for: $0) }
            let hits = hitsIds.compactMap { hit(with: $0) }
            let viewController = ImagesViewController(hits: hits)
            present(viewController, animated: true)
        }
    }
}


