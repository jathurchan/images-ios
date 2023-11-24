import UIKit

extension ImageGridViewController {
    @objc func didPressCancelButton() {
        print("pressed cancel")
        clearSelectedItems()
        updateToolbarButtons()
    }
    
    
    @objc func didPressDoneButton() {
        print("pressed done")
    }
}


