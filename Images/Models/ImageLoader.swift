import UIKit
import Foundation

class ImageLoader {
    
    public static let shared = ImageLoader()
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(HitImage, UIImage?) -> Void]]()
    
    private var imageDownloadingTasks = [HitImage.ID: URLSessionDataTask]()
    
    private func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func loadImage(url: NSURL, hit: HitImage, completionHandler: @escaping (HitImage, UIImage?) -> Void) {
        // Retrive cached image if possible
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completionHandler(hit, cachedImage)
            }
            return
        }
        
        // request already made by any other with another completion handler?
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completionHandler)
            return
        } else {
            loadingResponses[url] = [completionHandler]
        }
        
        // Confirm a task to download the image not already started?
        guard imageDownloadingTasks[hit.id] == nil else { return }
        
        let task = URLSession.shared.dataTask(with: url as URL) { [unowned self] (data, response, error) in
            
            // Remove the image downloading task
            imageDownloadingTasks[hit.id] = nil
            
            guard let data,
                  let image = UIImage(data: data),
                  let blocks = self.loadingResponses[url],
                  error == nil else {
                
                DispatchQueue.main.async {
                    completionHandler(hit, nil) // failed
                }
                return
            }
            
            self.cachedImages.setObject(image, forKey: url, cost: data.count)
            
            for block in blocks {
                DispatchQueue.main.async {
                    block(hit, image)
                }
                self.loadingResponses[url]?.remove(at: 0)
            }
        }
        task.resume()
        
        // Add the image downloading task to enable cancelling (prefetching...)
        imageDownloadingTasks[hit.id] = task
    }
    
    func cancelImageDownloadingTask(for hitImageId: HitImage.ID) {
        imageDownloadingTasks.removeValue(forKey: hitImageId)?.cancel()
    }
}
