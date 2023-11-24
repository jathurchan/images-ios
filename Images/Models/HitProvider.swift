import Foundation

class HitProvider {
    private(set) var hits: [Hit]
    
    private var isLoadingNextPage = false
    private var canLoadNextPage = true
    
    let client: PixabayClient
    
    init(_ hits: [Hit] = [Hit](), client: PixabayClient = PixabayClient()) {
        self.hits = hits
        self.client = client
    }
    
    func loadNextPage() {
        
    }
    
    func cancelLoading() {
        
    }
}
