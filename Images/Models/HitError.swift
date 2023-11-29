import Foundation

/// An enumeration that captures errors that may occur when
/// data is loaded using the Pixabay API and decoded into
/// an array of `Hit`. 
///
enum HitError: Error {
    
    /// An indication that some expected JSON properties
    /// to create a `Hit` were not found when decoding.
    case missingData
    
    /// An indication that the response returned by Pixabay
    /// was unsuccessful.
    case networkError
    
    case unexpectedError(Error: Error)
}
