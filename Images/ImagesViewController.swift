
import UIKit

class ImagesViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    let searchBar = UISearchBar(frame: .zero)
    var imagesCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ImageData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Images Search"
        
        configureHierarchy()
        configureDataSource()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(ImageData.sampleData)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ImagesViewController {
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <TemporaryCell, ImageData> { (cell, indexPath, imageData) in
            // Populate the cell with our item description.
            cell.label.text = String(imageData.id)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ImageData>(collectionView: imagesCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ImageData) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func performQuery(with filter: String?) {
        fatalError("to implement")
    }
}

extension ImagesViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(0.2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            
            return section
            
        }
        return layout
    }
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[searchBar]-20-[cv]|", options: [], metrics: nil, views: views))
        constraints.append(searchBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
        imagesCollectionView = collectionView
        
        searchBar.delegate = self
    }
}

extension ImagesViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        fatalError("Not implemented yet: perform query")
    }
}
