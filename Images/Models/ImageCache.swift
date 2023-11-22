import UIKit
import Foundation

class ImageCache {
    
    public static let shared = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(HitImage, UIImage?) -> Void]]()
    
    func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(url: NSURL, hit: HitImage, completionHandler: @escaping (HitImage, UIImage?) -> Void) {
        // Retrive cached image if possible
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completionHandler(hit, cachedImage)
            }
            return
        }
        
        // request already made?
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completionHandler)
            return
        } else {
            loadingResponses[url] = [completionHandler]
        }
        
        let task = URLSession.shared.dataTask(with: url as URL) { data, response, error in
            guard let data,
                  let image = UIImage(data: data),
                  let blocks = self.loadingResponses[url],
                  error == nil else {
                DispatchQueue.main.async {
                    completionHandler(hit, nil)
                }
                return
            }
            
            self.cachedImages.setObject(image, forKey: url, cost: data.count)
            
            for block in blocks {
                DispatchQueue.main.async {
                    block(hit, image)
                }
            }
        }
        task.resume()
    }
}
