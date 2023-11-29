import UIKit
import Foundation

/// A class used to load images given a URL and cache them
class ImageCache {
    public static let placeholderImage = UIImage()
    public static let shared = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(UIImage?) -> Void]]()
    
    /// Returns an UIImage if the image corresponding to the
    /// given URL is already cached
    private func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    /// Loads the image corresponding to the URL and passes it to the completion handler.
    ///
    /// - parameter url: A URL to the image to load.
    /// - parameter completion: Passes the loaded image if successful, else `nil`
    func loadImage(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        let task = URLSession.shared.dataTask(with: url as URL) { [unowned self] (data, response, error) in
            
            guard let data,
                  let image = UIImage(data: data),
                  let blocks = self.loadingResponses[url],
                  error == nil else {
                
                DispatchQueue.main.async {
                    completion(nil) // request to download failed
                }
                return
            }
            
            self.cachedImages.setObject(image, forKey: url, cost: data.count)
            
            for block in blocks {
                DispatchQueue.main.async {
                    block(image)
                }
                
            }
        }
        task.resume()
        
    }
}
