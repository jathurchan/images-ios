
import UIKit
import Combine

class ImageGridViewController: UIViewController {
    
    var dataSource: DataSource!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var hitsStore: HitProvider = HitProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = createLayout()
        collectionView.collectionViewLayout = layout
        
        searchBar.delegate = self
        collectionView.delegate = self
        
        configureDataSource()
        
        hitsStore.loadFirstPageData { [unowned self] hitIds, hitError in
            updateSnapshot()
        }
        
        collectionView.dataSource = dataSource
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.allowsMultipleSelection = true
        
        configureToolbar()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let largeItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)))
            largeItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let smallItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.5)))
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let smallGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [smallItem, smallItem])

            let leadingGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.5)),
                subitems: [largeItem, smallGroup])
            
            let trailingGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.5)),
                subitems: [smallGroup, largeItem])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingGroup, trailingGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        
        return layout
    }
    
    private func configureToolbar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancelButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didPressDoneButton))
        
        toolBar.setItems([cancelButton, spacer,  doneButton], animated: false)
        
        updateToolbarButtons()
    }
    
    func updateToolbarButtons() {
        if let indexPaths = collectionView.indexPathsForSelectedItems,
           !indexPaths.isEmpty {
            
            toolBar.items?[0].isEnabled = true  // Cancel button
            
            if indexPaths.count >= 2 {
                toolBar.items?[2].isEnabled = true  // Done button
            } else {
                toolBar.items?[2].isEnabled = false // Done button
            }
            
        } else {
            toolBar.items?[0].isEnabled = false // Cancel button
            toolBar.items?[2].isEnabled = false // Done button
        }
    }
}

extension ImageGridViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - 3 * scrollView.frame.size.height) {
            hitsStore.loadNextPageData { [unowned self] hitsIds, hitError in
                self.updateSnapshot(reloading: hitsIds)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let hitId = self.dataSource.itemIdentifier(for: indexPath) {
            self.updateSnapshot(reloading: [hitId])
        }
        
        updateToolbarButtons()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let hitId = self.dataSource.itemIdentifier(for: indexPath) {
            self.updateSnapshot(reloading: [hitId])
        }
        
        updateToolbarButtons()
    }
}

extension ImageGridViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            clearSelectedItems(animated: false)
            updateToolbarButtons()
            
            hitsStore.loadFirstPageData(for: text) { [unowned self] hitsIds, hitError in
                self.updateSnapshot(reloading: hitsIds)
            }
        }
        self.searchBar.endEditing(true)
        scrollToTop()
    }
    
    func clearSelectedItems(animated: Bool = false) {
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            indexPaths.forEach { (indexPath) in
                collectionView.deselectItem(at: indexPath, animated: animated)
            }
            self.updateSnapshot(reloading: indexPaths.compactMap { self.dataSource.itemIdentifier(for: $0) })
        }
    }
    
    private func scrollToTop() {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}
