import Foundation

struct Image: Identifiable {
    let id: Int
    let preview: URL
    let large: URL
}

extension Image: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case preview = "previewURL"
        case large = "largeImageURL"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try? values.decode(Int.self, forKey: .id)
        let rawPreview = try? values.decode(URL.self, forKey: .preview)
        let rawLarge = try? values.decode(URL.self, forKey: .large)
        
        guard let id = rawId,
              let preview = rawPreview,
              let large = rawLarge
        else {
            throw ImageError.missingData
        }
        
        self.id = id
        self.preview = preview
        self.large = large
    }
}

