import Foundation

struct PixabayJSON: Decodable {
    
    private(set) var hits: [Hit] = []
    
    private enum RootCodingKeys: String, CodingKey {
        case hits
    }
    
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
