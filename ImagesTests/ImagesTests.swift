
import XCTest
@testable import Images

final class ImagesTests: XCTestCase {
    
    func testHitDecoderDecodesImage() throws {
        let decoder = JSONDecoder()
        let hit = try decoder.decode(Hit.self, from: testImage_195893)
        
        XCTAssertEqual(hit.code, 195893)
        XCTAssertEqual(hit.preview.absoluteString, "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg")
        XCTAssertEqual(hit.large.absoluteString, "https://pixabay.com/get/ed6a99fd0a76647_1280.jpg")
        XCTAssertEqual(hit.user, "Josch13")
    }
    
    func testPixabayJSONDecoderDecodesPixabayJSON() throws {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(PixabayJSON.self, from: testPixabayJSON)
        
        XCTAssertEqual(decoded.hits.count, 1)
        XCTAssertEqual(decoded.hits[0].code, 195893)
        XCTAssertEqual(decoded.hits[0].preview.absoluteString, "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg")
        XCTAssertEqual(decoded.hits[0].large.absoluteString, "https://pixabay.com/get/ed6a99fd0a76647_1280.jpg")
        XCTAssertEqual(decoded.hits[0].user, "Josch13")
    }
    
}
