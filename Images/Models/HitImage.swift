import UIKit

struct HitImage: Identifiable {
    let id: Int
    let preview: URL
    let large: URL
    let user: String
    
    var image: UIImage = placeholderImage
}

extension HitImage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case preview = "previewURL"
        case largeImage = "largeImageURL"
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try? values.decode(Int.self, forKey: .id)
        let rawPreview = try? values.decode(URL.self, forKey: .preview)
        let rawLargeImage = try? values.decode(URL.self, forKey: .largeImage)
        let rawUser = try? values.decode(String.self, forKey: .user)
        
        guard let id = rawId,
              let preview = rawPreview,
              let largeImage = rawLargeImage,
              let user = rawUser
        else {
            throw HitError.missingData
        }
        
        self.id = id
        self.preview = preview
        self.large = largeImage
        self.user = user
    }
}

extension HitImage {
    private static let placeholderImage = UIImage(systemName: "photo.badge.arrow.down")!
}

#if DEBUG
extension HitImage {
    static let sampleData: [HitImage] = try! JSONDecoder().decode(PixabayJSON.self, from: PixabayJSON.sampleData).hits
}
#endif
