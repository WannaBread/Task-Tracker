import Foundation

// MARK: - App Error

enum AppError: Error, Equatable {
    case networkError(String)
    case authFailed(String)
    case invalidCredentials
    case sessionExpired
    case notFound
    case serverError(String)
    case unknown

    var localizedMessage: String {
        switch self {
        case .networkError(let msg):
            return "Network error: \(msg)"
        case .authFailed(let msg):
            return "Authentication failed: \(msg)"
        case .invalidCredentials:
            return "Invalid email or password"
        case .sessionExpired:
            return "Session expired. Please log in again"
        case .notFound:
            return "Data not found"
        case .serverError(let msg):
            return "Server error: \(msg)"
        case .unknown:
            return "Unknown error"
        }
    }
}
