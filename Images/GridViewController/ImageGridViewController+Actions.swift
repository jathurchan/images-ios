import UIKit

extension ImageGridViewController {
    @objc func didPressCancelButton() {
        clearSelectedItems()
        updateToolbarButtons()
    }
    
    
    @objc func didPressDoneButton() {
        fatalError()
    }
}


