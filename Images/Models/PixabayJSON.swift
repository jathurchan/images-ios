
import Foundation

struct PixabayJSON: Decodable {
    
    private enum RootCodingKeys: String, CodingKey {
        case hits
    }
    
    private(set) var images: [ImageData] = []
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var hitsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .hits)
        
        while !hitsContainer.isAtEnd {
            if let image = try? hitsContainer.decode(ImageData.self) {
                images.append(image)
            }
        }
    }
    
}
