import Foundation

enum HitError: Error {
    case missingData
    case networkError
    case unexpectedError(Error: Error)
}
