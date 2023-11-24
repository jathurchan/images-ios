import UIKit

extension ImagesViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = imageControllers.firstIndex(of: viewController) {
            if index > 0 {
                return imageControllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = imageControllers.firstIndex(of: viewController) {
            if index < imageControllers.count - 1 {
                return imageControllers[index + 1]
            } else {
                return nil
            }
        }

        return nil
    }
    
    
}
