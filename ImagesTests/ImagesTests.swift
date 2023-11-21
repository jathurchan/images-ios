
import XCTest
@testable import Images

final class ImagesTests: XCTestCase {
    
    func testHitDecoderDecodesImage() throws {
        let decoder = JSONDecoder()
        let image = try decoder.decode(ImageData.self, from: testImage_195893)
        
        XCTAssertEqual(image.id, 195893)
        XCTAssertEqual(image.preview.absoluteString, "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg")
        XCTAssertEqual(image.large.absoluteString, "https://pixabay.com/get/ed6a99fd0a76647_1280.jpg")
    }
    
    func testPixabayJSONDecoderDecodesPixabayJSON() throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(PixabayJSON.self, from: testPixabayJSON)
        
        XCTAssertEqual(decoded.images.count, 1)
        XCTAssertEqual(decoded.images[0].id, 195893)
        XCTAssertEqual(decoded.images[0].preview.absoluteString, "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg")
        XCTAssertEqual(decoded.images[0].large.absoluteString, "https://pixabay.com/get/ed6a99fd0a76647_1280.jpg")
    }
    
}
