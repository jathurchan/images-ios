
import UIKit

class ImageGridViewController: UIViewController {
    var dataSource: DataSource!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        fatalError("not implemented")
    }
    
}
