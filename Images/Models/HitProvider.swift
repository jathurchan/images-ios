import Foundation

class HitProvider {
    private static let hitsToLoadPerPage = 100
    
    var hits: [Hit] = []
    
    private let client: PixabayClient
    
    private var loadingPageTask: URLSessionDataTask?
    private var isLoadingNewPage: Bool { loadingPageTask != nil }
    private var canLoadNextPage: Bool = true
    
    private var query: String!
    private var pageToLoad: Int!
    private let perPage: Int = HitProvider.hitsToLoadPerPage
    
    func loadFirstPageData(for query: String = "", _ completion: @escaping ([Hit], HitError?) -> Void) {
        
        guard self.query != query else {
            return  // No need to reload
        }
        
        // Reset
        loadingPageTask?.cancel()
        canLoadNextPage = true
        self.query = query
        pageToLoad = 1
        hits = []  // remove previously loaded data
        
        
        loadPageData(query: query, page: pageToLoad, perPage: HitProvider.hitsToLoadPerPage, completion)
    }
    
    func loadNextPageData(_ completion: @escaping ([Hit]?, HitError?) -> Void) {
        if !isLoadingNewPage && canLoadNextPage {
            if let query,
               let pageToLoad {
                loadPageData(query: query, page: pageToLoad, perPage: perPage, completion)
            }
        }
    }
    
    private func loadPageData(query: String, page: Int, perPage: Int, _ completion: @escaping ([Hit], HitError?) -> Void) {
        loadingPageTask = client.loadHits(query: query, page: page, perPage: perPage, { [unowned self] loadedHits, hitError in
            
            self.loadingPageTask = nil  // enable loading new pages
            
            guard hitError == nil else {
                completion([], hitError)
                return
            }
            
            if loadedHits.count < self.perPage {    // reached last page?
                self.canLoadNextPage = false
            } else {
                self.pageToLoad += 1    // to load the next page later
            }
            
            self.hits.append(contentsOf: loadedHits)
            
            completion(loadedHits, nil)
            
        })
    }
    
    
    init(_ hits: [Hit] = [Hit](), client: PixabayClient = PixabayClient()) {
        self.hits = hits
        self.client = client
    }
}
