import UIKit

/// A model representing an image. It corresponds to a hit in
/// the JSON response returned by Pixabay.
struct Hit: Identifiable {
    
    /// An identifier that uniquely identifies a `Hit`.
    let id: UUID = UUID()
    
    /// An integer corresponding to the hit id in the
    /// JSON response returned by Pixabay.
    let code: Int
    
    /// A URL for the low resolution image with a
    /// maximum width or height of 150 px.
    let preview: URL
    
    /// A URL for the medium sized image with a
    /// maximum width or height of 640 px, valid
    /// for just 24 hours.
    let webFormat: URL
    
    /// User name of the contributor.
    let user: String
}

extension Hit: Decodable {
    private enum CodingKeys: String, CodingKey {
        case code = "id"
        case preview = "previewURL"
        case webFormat = "webformatURL"
        case user = "user"
    }
    
    /// Creates a new instance of `Hit` by decoding from the given decoder.
    ///
    /// - throws: `HitError.missingData` if the expected JSON
    ///     properties to create a `Hit` were not found.
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

extension [Hit] {
    
    /// Returns the first index in which the hit id matches the given id.
    ///
    /// - Parameter id: The id of the Hit for which we are looking for the index.
    /// - Returns: The index of the first Hit for which the id is the same as
    ///     `id`. If no Hits in the array has the same id as `id`, returns `nil`.
    func indexOfHit(with id: Hit.ID) -> Self.Index? {
        return firstIndex(where: { $0.id == id })
    }
    
}
