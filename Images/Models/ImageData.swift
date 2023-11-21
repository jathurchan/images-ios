import UIKit

enum ImageDataError: Error {
    case missingData
    case networkError   // TODO: New case for 429 error: API rate limit exceeded
    case unexpectedError(Error: Error)
}

struct ImageData: Hashable {
    static let placeholder: UIImage = UIImage(systemName: "photo.fill")!
    
    let id: Int
    let preview: URL
    let large: URL
    var image: UIImage! = ImageData.placeholder  // TODO: Update
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ImageData: Decodable {
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
            throw ImageDataError.missingData
        }
        
        self.id = id
        self.preview = preview
        self.large = large
    }
}

extension ImageData {
    static let testPixabayJSON: Data = """
    {
    "total": 1,
    "totalHits": 1,
    "hits": [
        {
            "id": 195893,
            "pageURL": "https://pixabay.com/en/blossom-bloom-flower-195893/",
            "type": "photo",
            "tags": "blossom, bloom, flower",
            "previewURL": "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg",
            "previewWidth": 150,
            "previewHeight": 84,
            "webformatURL": "https://pixabay.com/get/35bbf209e13e39d2_640.jpg",
            "webformatWidth": 640,
            "webformatHeight": 360,
            "largeImageURL": "https://pixabay.com/get/ed6a99fd0a76647_1280.jpg",
            "fullHDURL": "https://pixabay.com/get/ed6a9369fd0a76647_1920.jpg",
            "imageURL": "https://pixabay.com/get/ed6a9364a9fd0a76647.jpg",
            "imageWidth": 4000,
            "imageHeight": 2250,
            "imageSize": 4731420,
            "views": 7671,
            "downloads": 6439,
            "likes": 5,
            "comments": 2,
            "user_id": 48777,
            "user": "Josch13",
            "userImageURL": "https://cdn.pixabay.com/user/2013/11/05/02-10-23-764_250x250.jpg"
        },
    ]
    }
""".data(using: .utf8)!

    static let sampleData = try! JSONDecoder().decode(PixabayJSON.self, from: testPixabayJSON).images
}

