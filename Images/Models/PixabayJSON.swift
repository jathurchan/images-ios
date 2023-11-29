import Foundation

/// A model representing the JSON response
/// returned by Pixabay.
struct PixabayJSON: Decodable {
    
    /// The array of hits decoded from the JSON response
    /// returned by Pixabay.
    private(set) var hits: [Hit] = []
    
    private enum RootCodingKeys: String, CodingKey {
        case hits
    }
    
    /// Creates a new instance of `PixabayJSON` by decoding
    /// from the given decoder.
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var hitsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .hits)
        
        while !hitsContainer.isAtEnd {
            if let hit = try? hitsContainer.decode(Hit.self) {
                hits.append(hit)
            }
        }
    }
}
