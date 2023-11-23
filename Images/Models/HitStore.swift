import Foundation

class HitStore {
    var hits = [Hit]()
    
    init(_ hits: [Hit] = [Hit]()) {
        self.hits = hits
    }
}
