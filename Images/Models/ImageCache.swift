import UIKit
import Foundation

class ImageCache {
    
    public static let shared = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(Hit.ID, UIImage?) -> Void]]()
    
    // private var imageDownloadingTasks = [Hit.ID: URLSessionDataTask]()
    
    private func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func loadImage(url: NSURL, hitId: Hit.ID, completion: @escaping (Hit.ID, UIImage?) -> Void) {
        
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(hitId, cachedImage)
            }
            return
        }
        
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        // Confirm a task to download the image not already started?
        // guard imageDownloadingTasks[hitID] == nil else { return }
        
        let task = URLSession.shared.dataTask(with: url as URL) { [unowned self] (data, response, error) in
            
            // Remove the image downloading task
            // imageDownloadingTasks[hit.id] = nil
            
            guard let data,
                  let image = UIImage(data: data),
                  let blocks = self.loadingResponses[url],
                  error == nil else {
                
                DispatchQueue.main.async {
                    completion(hitId, nil) // request to download failed
                }
                return
            }
            
            
            
            self.cachedImages.setObject(image, forKey: url, cost: data.count)
            
            for block in blocks {
                DispatchQueue.main.async {
                    block(hitId, image)
                }
                
                // self.loadingResponses[url]?.remove(at: 0)
            }
        }
        task.resume()
        
        // Add the image downloading task to enable cancelling (prefetching...)
        // imageDownloadingTasks[hit.id] = task
    }
    
    func cancelImageDownloadingTask(for hitImageId: Hit.ID) {
        fatalError()
        // imageDownloadingTasks.removeValue(forKey: hitImageId)?.cancel()
    }
}
