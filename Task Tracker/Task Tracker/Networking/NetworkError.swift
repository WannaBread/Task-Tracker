import Foundation

// MARK: - NetworkError (D1)

enum NetworkError: Error {
    case badURL
    case requestFailed(statusCode: Int)
    case noData
    case decodingFailed(Error)
    case cancelled
    case underlying(Error)

    var localizedDescription: String {
        switch self {
        case .badURL:
            return "The request URL was invalid."
        case .requestFailed(let code):
            return "The server returned an error (HTTP \(code))."
        case .noData:
            return "No data was returned by the server."
        case .decodingFailed(let err):
            return "Response could not be parsed: \(err.localizedDescription)"
        case .cancelled:
            return "The request was cancelled."
        case .underlying(let err):
            return err.localizedDescription
        }
    }
}

// MARK: - AppError bridge

extension NetworkError {
    /// Maps a NetworkError into the domain-level AppError used throughout the app.
    func asAppError() -> AppError {
        switch self {
        case .badURL, .noData, .underlying:
            return .networkError(localizedDescription)
        case .decodingFailed:
            return .networkError(localizedDescription)
        case .requestFailed(let code) where (500...599).contains(code):
            return .serverError("HTTP \(code)")
        case .requestFailed:
            return .networkError(localizedDescription)
        case .cancelled:
            return .networkError("Request was cancelled.")
        }
    }
}
