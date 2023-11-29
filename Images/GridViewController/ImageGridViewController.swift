
import UIKit
import Combine

class ImageGridViewController: UIViewController {
    
    var dataSource: DataSource!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var hitsStore: HitProvider = HitProvider()
    
    private let cancelButtonIndex = 0
    private let selectedLabelButton = 2
    private let doneButtonIndex = 4
    
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
    
    /// Creates the layout for the collection view
    /// It is as follows:
    ///     (1) large image + (2 small images)
    ///     (2) (2 small images) + large image
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
    
    /// Creates the toolbar with the initial state
    private func configureToolbar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancelButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didPressDoneButton))
        let selectedLabelButton = UIBarButtonItem(customView: UILabel())
        
        toolBar.setItems([cancelButton, spacer, selectedLabelButton, spacer, doneButton], animated: false)
        
        updateToolbarButtons()
    }
}

// MARK: UICollectionViewDelegate
extension ImageGridViewController: UICollectionViewDelegate {
    
    /// Loads next page and updates the array of `Hit` in `hitsStore` as soon as
    /// the user has scrolled far enough and updates asynchronously the snapshot to
    /// update the collection view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - 3 * scrollView.frame.size.height) {
            hitsStore.loadNextPageData { [unowned self] hitsIds, hitError in
                self.updateSnapshot(reloading: hitsIds)
            }
        }
    }
    
    /// Updates snapshot to show the selection and updates the toolbar
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let hitId = self.dataSource.itemIdentifier(for: indexPath) {
            self.updateSnapshot(reloading: [hitId])
        }
        
        updateToolbarButtons()
    }
    
    /// Updates snapshot to show the deselection and updates the toolbar
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let hitId = self.dataSource.itemIdentifier(for: indexPath) {
            self.updateSnapshot(reloading: [hitId])
        }
        
        updateToolbarButtons()
    }
}

// MARK: UISearchBarDelegate
extension ImageGridViewController: UISearchBarDelegate {
    
    /// Initiates a new search
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
    
    private func scrollToTop() {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}

// MARK: Utilities
extension ImageGridViewController {
    
    /// Updates the toolbar according to the number of images
    /// currently selected in the collection view
    func updateToolbarButtons() {
        let selectedLabel = UILabel()
        selectedLabel.font = .preferredFont(forTextStyle: .headline)
        
        if let indexPaths = collectionView.indexPathsForSelectedItems,
           !indexPaths.isEmpty {
            
            toolBar.items?[cancelButtonIndex].isEnabled = true
            
            selectedLabel.text = "\(indexPaths.count) "
            
            if indexPaths.count >= 2 {
                toolBar.items?[doneButtonIndex].isEnabled = true
                selectedLabel.text! += "Images Selected"
            } else {
                toolBar.items?[doneButtonIndex].isEnabled = false
                selectedLabel.text! += "Image Selected"
            }
            
        } else {
            toolBar.items?[cancelButtonIndex].isEnabled = false
            toolBar.items?[doneButtonIndex].isEnabled = false
            
            selectedLabel.text = "Select Images"
        }
        
        toolBar.items?[selectedLabelButton].customView = selectedLabel
    }
    
    /// Deselect all the selected images and update the snapshot
    func clearSelectedItems(animated: Bool = false) {
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            indexPaths.forEach { (indexPath) in
                collectionView.deselectItem(at: indexPath, animated: animated)
            }
            self.updateSnapshot(reloading: indexPaths.compactMap { self.dataSource.itemIdentifier(for: $0) })
        }
    }
}
