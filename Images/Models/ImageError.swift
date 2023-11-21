
import Foundation

enum ImageDataError: Error {
    case missingData
    case networkError   // TODO: New case for 429 error: API rate limit exceeded
    case unexpectedError(Error: Error)
}
