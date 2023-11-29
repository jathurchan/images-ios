import Foundation

let validStatus = 200...299

class PixabayClient {
    private static let apiKey = "18021445-326cf5bcd3658777a9d22df6f"
    private static let baseURL = URL(string: "https://pixabay.com/api/")!
    
    private lazy var decoder: JSONDecoder = JSONDecoder()
    
    /// Makes a GET request to Pixabay with the right query parameters and
    /// calls the completion handler asynchronously with the results.
    ///
    /// - parameter query: A string that represents the search term.
    /// - parameter page: An integer that represents the page to load.
    /// - parameter perPage: An integer (between 3 and 200) that represents
    ///     the number of results per page to load.
    /// - parameter completion: Passes an array of `Hit` decoded from the
    ///     JSON response returned from Pixabay as the first parameter and `nil`
    ///     as the second parameter if successful. Passes an empty array and a
    ///     `HitError` else.
    /// - returns: The task that is loading the array of hits, enabling cancellation.
    func loadHits(query: String = "", page: Int?, perPage: Int?, _ completion: @escaping ([Hit], HitError?) -> Void) -> URLSessionDataTask? {
        
        let url = buildEncodedUrl(query: query, page: page, perPage: perPage)
        
        let task = URLSession.shared.dataTask(with: url as URL) { [unowned self] (data, response, _) in
            
            guard let data,
                  let response = response as? HTTPURLResponse,
                  validStatus.contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion([], HitError.networkError)
                }
                return
            }
            
            do {
                let pixabayJSON: PixabayJSON = try self.decoder.decode(PixabayJSON.self, from: data)
                DispatchQueue.main.async {
                    completion(pixabayJSON.hits, nil)   // Success
                }
                
            } catch HitError.missingData {
                DispatchQueue.main.async {
                    completion([], .missingData)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion([], HitError.unexpectedError(Error: error))
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
    /// Returns the encoded URL to be used to load the right data from Pixabay
    /// according to the `query`, `page`, and `perPage` parameters.
    ///
    /// - parameter query: A string that represents the search term. If the
    ///     query is empty, q parameter in the URL is ignored. If it exceeds 100
    ///     characters, It is truncated. Any characters that are not allowed are
    ///     replaced with percent encoded characters.
    /// - parameter page: An integer that represents the page to load. If it
    ///     is `nil`, the page parameter in the URL is ignored.
    /// - parameter perPage: An integer (between 3 and 200) that represents
    ///     the number of results per page to load. If it is `nil`, the page parameter
    ///     in the URL is ignored.
    /// - returns: An encoded URL
    private func buildEncodedUrl(query: String, page: Int?, perPage: Int?) -> URL {
        
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "key", value: PixabayClient.apiKey)]
        
        if var query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           query != "" {
            query = String(query.prefix(100))   // Truncate if > 100
            queryItems.append(URLQueryItem(name: "q", value: query))
        }
        
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        
        if let perPage {
            guard perPage <= 200 && perPage >= 3 else {
                fatalError("Accepted values: 3 - 200")
            }
            queryItems.append(URLQueryItem(name: "per_page", value: String(perPage)))
        }
        
        let url = PixabayClient.baseURL.appending(queryItems: queryItems)
        return url
    }
    
}
