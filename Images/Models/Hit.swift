import UIKit

struct Asset: Identifiable {
    static let noAsset: Asset = Asset(id: "none", image: UIImage(systemName: "photo.badge.arrow.down.fill")!)
    
    let id: String  // String of hit id except for noAsset
    var image: UIImage
}

struct Hit: Identifiable {
    let id: Int
    let preview: URL
    let largeImage: URL
    let user: String
}

extension Hit: Decodable {
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
        self.largeImage = largeImage
        self.user = user
    }
}

#if DEBUG
extension Hit {
    static let sampleData: [Hit] = try! JSONDecoder().decode(PixabayJSON.self, from: PixabayJSON.sampleData).hits
}
#endif
