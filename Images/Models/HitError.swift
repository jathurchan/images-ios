import Foundation

/// An enumeration that captures errors that may occur when
/// data is loaded using the Pixabay API and decoded into
/// an array of `Hit`.
enum HitError: Error {
    
    /// An indication that some expected JSON properties
    /// were not found when decoding to create a `Hit`.
    case missingData
    
    /// An indication that the response received after the
    /// GET request made using the Pixabay API was
    /// unsuccessful.
    case networkError
    
    /// An indication that the error thrown was not
    /// expected.
    case unexpectedError(Error: Error)
}
