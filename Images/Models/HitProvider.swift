import Foundation

/// A class that manages the array of `Hit` that is associated with a search query.
class HitProvider {
    private static let hitsToLoadPerPage = 100
    
    /// An array of `Hit` currently loaded.
    /// It is either updated by scrolling or performing a new query.
    private(set) var hits: [Hit] = []
    
    private let client: PixabayClient
    
    /// The task that is currently loading a new page of hits
    private var loadingPageTask: URLSessionDataTask?
    private var isLoadingNewPage: Bool { loadingPageTask != nil }
    private var canLoadNextPage: Bool = true
    
    private var query: String!
    private var pageToLoad: Int!
    private let perPage: Int = HitProvider.hitsToLoadPerPage
    
    /// Loads the first page of hits for a given query
    func loadFirstPageData(for query: String = "", _ completion: @escaping ([Hit.ID], HitError?) -> Void) {
        
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
    
    /// Loads the next page of hits if the next page is not
    /// already being loaded, the next page exists and
    /// `loadFirstPageData` was already called
    func loadNextPageData(_ completion: @escaping ([Hit.ID], HitError?) -> Void) {
        if !isLoadingNewPage && canLoadNextPage {
            
            if let query,   // if loadFirstPageData was already called
               let pageToLoad {
                loadPageData(query: query, page: pageToLoad, perPage: perPage, completion)
            }
        }
    }
    
    private func loadPageData(query: String, page: Int, perPage: Int, _ completion: @escaping ([Hit.ID], HitError?) -> Void) {
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
            
            completion(loadedHits.map { $0.id }, nil)
            
        })
    }
    
    
    init(_ hits: [Hit] = [Hit](), client: PixabayClient = PixabayClient()) {
        self.hits = hits
        self.client = client
    }
}
