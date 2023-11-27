import UIKit

struct Hit: Identifiable {
    let id: UUID = UUID()
    let code: Int
    let preview: URL
    let webFormat: URL
    let user: String
    
    var asset = UIImage()
}

extension [Hit] {
    func indexOfHit(with id: Hit.ID) -> Self.Index? {
        return firstIndex(where: { $0.id == id })
    }
}

extension Hit: Decodable {
    private enum CodingKeys: String, CodingKey {
        case code = "id"
        case preview = "previewURL"
        case webFormat = "webformatURL"
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawCode = try? values.decode(Int.self, forKey: .code)
        let rawPreview = try? values.decode(URL.self, forKey: .preview)
        let rawWebFormat = try? values.decode(URL.self, forKey: .webFormat)
        let rawUser = try? values.decode(String.self, forKey: .user)
        
        guard let code = rawCode,
              let preview = rawPreview,
              let image = rawWebFormat,
              let user = rawUser
        else {
            throw HitError.missingData
        }
        
        self.code = code
        self.preview = preview
        self.webFormat = image
        self.user = user
    }
}
